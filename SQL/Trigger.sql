USE QLCUAHANG
GO

--SAN PHAM
--Kiểm tra khi thêm hoặc sửa thông tin mặt hàng
CREATE TRIGGER trg_KtraSanPham
ON SAN_PHAM
AFTER INSERT, UPDATE
AS
BEGIN 
	-- Kiểm tra ten
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(ten_sp) = '')
	BEGIN 
		RAISERROR('Tên mặt hàng không được để trống', 16, 1)
		ROLLBACK TRANSACTION 
		RETURN 
	END

	-- Kiểm tra trùng tên
	IF EXISTS (
		SELECT 1 
		FROM SAN_PHAM sp
		INNER JOIN inserted i ON TRIM(sp.ten_sp) = TRIM(i.ten_sp)
		WHERE sp.ma_sp <> i.ma_sp  -- Loại trừ việc so sánh với chính bản ghi đang được cập nhật
	)
	BEGIN 
		RAISERROR('Tên mặt hàng đã tồn tại trong bảng', 16, 1)
		ROLLBACK TRANSACTION 
		RETURN 
	END

	 -- Kiểm tra p_size
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(kthuoc_sp) = '')
    BEGIN
        RAISERROR('Kích thước mặt hàng không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;
GO

--Kiểm tra ngày nhập lô hàng
CREATE TRIGGER trg_KtraLoHang 
ON LO_HANG
AFTER INSERT, UPDATE
AS 
BEGIN 
	IF NOT EXISTS (SELECT * FROM inserted 
	WHERE (DATEDIFF(DAY, [ngay_nhap], GETDATE()) >= 0))
	BEGIN
		RAISERROR ('Ngày nhập lô hàng không thể là trong tương lai', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
END;

--Cập nhật số lượng mặt hàng sau khi thêm vào kho thành công
CREATE TRIGGER trg_CapNhatKho
ON CHI_TIET_LO_HANG
AFTER INSERT
AS
BEGIN
	DECLARE @ma_sp VARCHAR(10), @sluong_nhap INT

	SELECT @ma_sp = ma_sp, @sluong_nhap = sluong_nhap
	FROM inserted

	UPDATE SAN_PHAM
	SET sluong_sp = sluong_sp + @sluong_nhap
	WHERE ma_sp = @ma_sp
END;
GO

--KHACH HANG
--Kiểm tra trước khi thêm và cập nhật khách hàng
CREATE TRIGGER trg_KtraKhachHang
ON KHACH_HANG 
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(ten_kh) = '')
	BEGIN 
		RAISERROR ('Tên khách hàng không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
END;
GO

--NHANVIEN
--Kiểm tra khi thêm hoặc sửa thông tin nhân viên
CREATE TRIGGER trg_KtrNhanVien
ON NHAN_VIEN
AFTER INSERT, UPDATE
AS
BEGIN 
	-- Kiểm tra tên nhân viên
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(ten_nv) = '')
	BEGIN
		RAISERROR ('Tên nhân viên không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

	-- Kiểm tra giới tính nhân viên
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(gtinh_nv) = '')
	BEGIN
		RAISERROR ('Giới tính nhân viên không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

	IF EXISTS (
		SELECT 1
		FROM NHAN_VIEN nv
		INNER JOIN inserted i ON TRIM(nv.sdt_nv) = TRIM(i.sdt_nv)
		WHERE nv.ma_nv <> i.ma_nv AND nv.tthai_nv = 1
	)
	BEGIN 
		RAISERROR ('Số điện thoại đã được sử dụng', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

	-- Kiểm tra địa chỉ nhân viên
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(dchi_nv) = '')
	BEGIN
		RAISERROR ('Địa chỉ không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
END;
GO

--TAI KHOAN
--Kiểm tra khi thêm và cập nhật tài khoản nhân viên
CREATE TRIGGER trg_KtraTaiKhoan
ON TAI_KHOAN
AFTER INSERT, UPDATE
AS
BEGIN
	--Kiểm tra mat khau
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(mkhau) = '')
	BEGIN
		RAISERROR ('Password không được để trống', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
END;

--Thêm tài khoản khi tạo tài khoản mới
CREATE TRIGGER trg_ThemTaiKhoan
ON TAI_KHOAN
AFTER INSERT
AS
BEGIN
	DECLARE @tkhoan VARCHAR(50),
			@mkhau VARCHAR(25),
			@role INT 
	SELECT @tkhoan = i.tkhoan, @mkhau = i.mkhau, @role = i.role
	FROM inserted i

	DECLARE @sqlString VARCHAR(2000)
	SET @sqlString = 'CREATE LOGIN [' + @tkhoan + '] WITH PASSWORD=''' + @mkhau + ''', 
					DEFAULT_DATABASE=[QLCUAHANG], 
					CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF'
	EXEC (@sqlString)

	SET @sqlString = 'CREATE USER ' + @tkhoan + ' FOR LOGIN ' + @tkhoan
	EXEC (@sqlString)

	IF (@role = 1)
		SET @sqlString = 'ALTER SERVER ROLE sysadmin ADD MEMBER ' + @tkhoan
	ELSE
		SET @sqlString = 'ALTER ROLE Staff ADD MEMBER ' + @tkhoan

	EXEC (@sqlString)
END;

--Cập nhật mật khẩu 
CREATE TRIGGER trg_CapNhatMatKhau
ON TAI_KHOAN
AFTER UPDATE
AS
BEGIN
	DECLARE @tkhoan VARCHAR(50), @mkhau VARCHAR(25)

	SELECT @tkhoan = i.tkhoan, @mkhau = i.mkhau 
	FROM inserted i

	IF UPDATE(mkhau)
	BEGIN 
		DECLARE @sqlString VARCHAR(2000)
		SET @sqlString = 'ALTER LOGIN [' + @tkhoan + '] WITH PASSWORD = '''+ @mkhau + ''''
		EXEC (@sqlString)
	END
END;
GO

--NHA CUNG CAP
--Kiểm tra khi thêm và cập nhật thông tin nhà cung cấp 
CREATE TRIGGER trg_KtraNhaCungCap
ON NHA_CUNG_CAP
AFTER INSERT, UPDATE
AS 
BEGIN
	--Kiểm tra tên
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(ten_ncc) = '')
	BEGIN
		RAISERROR ('Tên nhà cung cấp không được để trống.', 16, 1)
		ROLLBACK TRANSACTION
		RETURN 
	END

	--Kiểm tra dia chi
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(dchi_ncc) = '')
	BEGIN
		RAISERROR ('Địa chỉ nhà cung cấp không được để trống.', 16, 1)
		ROLLBACK TRANSACTION
		RETURN 
	END
END;
GO

--Tự động trừ hàng trong kho khi khách mua
CREATE TRIGGER trg_TruSanPham
ON CHI_TIET_HOA_DON
AFTER INSERT
AS
BEGIN
	DECLARE @ma_sp VARCHAR(10), @sluong INT

	SELECT @ma_sp = i.ma_sp, @sluong = i.sluong
	FROM inserted i

	UPDATE SAN_PHAM
	SET sluong_sp = sluong_sp - @sluong
	WHERE ma_sp = @ma_sp
END;
GO

--Cập nhật điểm cho khách hàng
CREATE TRIGGER trg_CapNhatDiem
ON HOA_DON
AFTER INSERT
AS
BEGIN
	DECLARE @ma_hd VARCHAR(10), 
			@diem_tluy DECIMAL(15, 0),
			@sdt_kh	VARCHAR(10),
			@tong_tien DECIMAL(15, 0),
			@giam_gia DECIMAL(15, 0)

	SELECT @ma_hd = i.ma_hd, @sdt_kh = i.sdt_kh, 
			@tong_tien = i.tong_tien, @giam_gia = i.giam_gia
	FROM inserted i
	SELECT @diem_tluy = kh.diem_tluy 
	FROM KHACH_HANG kh
	WHERE sdt_kh = @sdt_kh

	UPDATE KHACH_HANG
	SET diem_tluy = CASE
		WHEN @tong_tien - @giam_gia	- @diem_tluy > 0
			THEN (@tong_tien - @giam_gia - @diem_tluy) * 0.02
		ELSE @diem_tluy - (@tong_tien - @giam_gia) + ((@tong_tien - @giam_gia) * 0.02)
		END
	WHERE sdt_kh = @sdt_kh

	UPDATE HOA_DON
	SET tong_tien = CASE
		WHEN  @tong_tien - @giam_gia - @diem_tluy > 0
			THEN  @tong_tien - @giam_gia - @diem_tluy 
		ELSE 0
		END
	WHERE ma_hd = @ma_hd
END;
GO


