--SAN PHAM
--THEM SAN PHAM
CREATE PROC sp_ThemSanPham 
	@ma VARCHAR(10),
	@ten NVARCHAR(255),
	@gia DECIMAL(15,0),
	@anh IMAGE,
	@kthuoc VARCHAR(10),
	@sluong INT
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN INSERT_PRO 
		INSERT INTO  SAN_PHAM VALUES(@ma, @ten, @gia, @anh, @kthuoc, @sluong, DEFAULT)
		COMMIT TRAN
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN INSERT_PRO
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16,1)
	END CATCH
END 
GO

--CAP NHAT SAN PHAM
CREATE PROC sp_CapNhatSanPham 
	@ma VARCHAR(10),
	@ten NVARCHAR(255),
	@gia DECIMAL(15,0),
	@anh IMAGE,
	@kthuoc VARCHAR(10),
	@sluong INT
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Update_sp
		UPDATE SAN_PHAM
		SET ten_sp = @ten, gia = @gia, anh = @anh, kthuoc_sp = @kthuoc, sluong_sp = @sluong
		WHERE ma_sp = @ma
		COMMIT TRAN
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN Update_sp
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16, 1)
	END CATCH
END 
GO

--XOA SAN PHAM
CREATE PROC sp_XoaSanPham 
	@ma VARCHAR(10)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Delete_sp
		UPDATE SAN_PHAM
		SET tthai_sp = 0
		WHERE ma_sp = @ma
		COMMIT TRAN
	END TRY
	BEGIN CATCH 
		PRINT N'Không thể xóa sản phẩm'
		ROLLBACK TRAN Delete_sp
	END CATCH
END 
GO

--TẠO MÃ SẢN PHẨM TỰ ĐỘNG
CREATE PROC sp_TaoMaSPTuDong @ma VARCHAR(10)
AS 
BEGIN
	BEGIN TRY 
		SELECT CONCAT(@ma, RIGHT (CONCAT('000', ISNULL(RIGHT(MAX(ma_sp),4),0) + 1),4))
		FROM SAN_PHAM WHERE ma_sp LIKE @ma + '%'
	END TRY
	BEGIN CATCH
		PRINT 'Có lỗi xảy ra'
		PRINT ERROR_MESSAGE()
	END CATCH;
END
GO

--LÔ HÀNG
--THEM LO HANG MOI
CREATE PROC sp_ThemLoHang 
	@malo VARCHAR(10), 
	@mancc VARCHAR(10), 
	@ngay DATE
AS
BEGIN 
	BEGIN TRY
		BEGIN TRAN insert_lo
		INSERT INTO dbo.LO_HANG VALUES (@malo, @mancc, @ngay, default)
		COMMIT TRAN insert_lo
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN insert_lo
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR(@er, 16,1)
	END CATCH
END
GO

--Thêm thông tin mặt hàng trong lô hàng mới
CREATE PROCEDURE sp_ThemChiTietLo
	@malo VARCHAR(10), 
	@masp VARCHAR(10), 
	@gia DECIMAL(15, 0),
	@sluong INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN insert_ChiTietLo
		-- Thêm dữ liệu vào bảng DETAIL_SHIPMENT
		INSERT INTO dbo.CHI_TIET_LO_HANG VALUES(@malo, @masp, @gia, @sluong, default)
		COMMIT TRAN insert_ChiTietLo
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN insert_ChiTietLo
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--Xóa lô hàng
CREATE PROC sp_XoaLoHang
	@malo VARCHAR(10)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN xoa_Lohang
		--Xóa dữ liệu tương ứng trong chi tiết lô hàng
		UPDATE CHI_TIET_LO_HANG SET tthai_ctlh = 0 WHERE ma_lo = @malo
		--Xóa lô hàng
		UPDATE LO_HANG SET tthai_lo = 0 WHERE ma_lo = @malo
		COMMIT TRAN xoa_Lohang
	END TRY
	BEGIN CATCH
		Print N'Không thể xóa lô hàng' 
		Rollback Tran xoa_Lohang
	END CATCH
END
GO

--TẠO MÃ LO HANG TỰ ĐỘNG
CREATE PROC sp_TaoMaLoTuDong 
AS 
BEGIN
	BEGIN TRY 
		SELECT CONCAT('LO', RIGHT (CONCAT('000', ISNULL(RIGHT(MAX(ma_lo),4),0) + 1),4))
		FROM LO_HANG WHERE ma_lo LIKE 'LO' + '%'
	END TRY
	BEGIN CATCH
		PRINT 'Có lỗi xảy ra'
		PRINT ERROR_MESSAGE()
	END CATCH;
END
GO

--KHACH HANG
--THEM KHACH HANG
CREATE PROC sp_ThemKhachHang
	@sdt VARCHAR(10),
	@ten NVARCHAR(50),
	@diem DECIMAL(15,0),
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN insert_KhachHang 
		INSERT INTO  KHACH_HANG(sdt_kh, ten_kh, diem_tluy, tthai_kh) 
			VALUES(@sdt, @ten, @diem, DEFAULT)
		COMMIT TRAN insert_KhachHang
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN insert_KhachHang
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16,1)
	END CATCH
END 
GO
--CAP NHAT KKHACH HANG
CREATE PROC sp_CapNhatKhachHang
	@sdt VARCHAR(10),
	@ten NVARCHAR(50),
	@diem DECIMAL(15,0),
	@tthai BIT
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Update_KH
		UPDATE KHACH_HANG
		SET ten_kh = @ten, diem_tluy = @diem, tthai_kh = @tthai
		WHERE sdt_kh = @sdt
		COMMIT TRAN Update_KH
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN Update_KH
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16, 1)
	END CATCH
END 
GO

--XOA KHACH HANG
CREATE PROC sp_XoaKhachHang
	@sdt VARCHAR(10)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Delete_KH
		UPDATE KHACH_HANG SET tthai_kh = 0
		WHERE sdt_kh = @sdt
		COMMIT TRAN Delete_KH
	END TRY
	BEGIN CATCH 
		PRINT N'Không thể xóa khách hàng'
		ROLLBACK TRAN Delete_KH
	END CATCH
END 
GO

--NHAN VIEN
--THEM NHAN VIEN
CREATE PROC sp_ThemNhanVien
		@ma VARCHAR(10),
	@ten NVARCHAR(50),
	@sdt VARCHAR(10),
	@diaChi VARCHAR(255),
	@gtinh VARCHAR(10)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN insert_NV
		INSERT INTO  NHAN_VIEN(ma_nv, ten_nv, sdt_nv, dchi_nv, gtinh_nv) 
			VALUES(@ma, @ten, @sdt, @diaChi, @gtinh)
		COMMIT TRAN insert_NV
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN insert_NV
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16,1)
	END CATCH
END
GO
--CAP NHAT NHAN VIEN
CREATE PROC sp_CapNhatNhanVien
		@ma VARCHAR(10),
	@ten NVARCHAR(50),
	@diaChi VARCHAR(255),
	@sdt VARCHAR(10),
	@gtinh VARCHAR(10)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Update_NV
		UPDATE NHAN_VIEN
		SET ten_nv = @ten, dchi_nv = @diaChi, sdt_nv = @sdt, gtinh_nv = @gtinh
		WHERE ma_nv = @ma
		COMMIT TRAN Update_NV
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN Update_NV
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16, 1)
	END CATCH
END
GO

--XOA NHAN VIEN
CREATE PROC sp_XoaNhanVien
	@ma VARCHAR(10)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Delete_NV
		UPDATE NHAN_VIEN SET tthai_nv = 0
		WHERE ma_nv = @ma
		COMMIT TRAN Delete_NV
	END TRY
	BEGIN CATCH 
		PRINT N'Không thể xóa nhân viên'
		ROLLBACK TRAN Delete_NV
	END CATCH
END 
GO

--NHA CUNG CAP
--THEM NHA CUNG CAP 
CREATE PROC sp_ThemNhaCungCap
	@ma VARCHAR(10),
	@ten NVARCHAR(50),
	@sdt VARCHAR(10),
	@diaChi NVARCHAR(255)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN insert_Ncc
		INSERT INTO  NHA_CUNG_CAP(ma_ncc, ten_ncc, sdt_ncc, dchi_ncc, tthai_ncc) 
			VALUES(@ma, @ten, @sdt, @diaChi, DEFAULT)
		COMMIT TRAN insert_Ncc
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN insert_Ncc
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16,1)
	END CATCH
END 
GO

--CAP NHAT NHA CUNG CAP
CREATE PROC sp_CapNhatNhaCungCap
	@ma VARCHAR(10),
	@ten NVARCHAR(50),
	@diaChi NVARCHAR(255),
	@sdt VARCHAR(10)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Update_Ncc
		UPDATE NHA_CUNG_CAP
		SET ten_ncc = @ten, dchi_ncc = @diaChi, sdt_ncc = @sdt, tthai_ncc = @tthai
		WHERE ma_ncc = @ma
		COMMIT TRAN Update_Ncc
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN Update_Ncc
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16, 1)
	END CATCH
END 
GO

--XOA NHA CUNG CAP
CREATE PROC sp_XoaNhaCungCap
	@ma VARCHAR(10)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Delete_Ncc
		UPDATE NHA_CUNG_CAP SET tthai_ncc = 0
		WHERE ma_ncc = @ma
		COMMIT TRAN Delete_Ncc
	END TRY
	BEGIN CATCH 
		PRINT N'Không thể xóa Nhà cung cấp'
		ROLLBACK TRAN Delete_Ncc
	END CATCH
END 
GO

--TẠO MÃ NHA CUNG CAP TỰ ĐỘNG
CREATE PROC sp_TaoMaNCCTuDong 
AS 
BEGIN
	BEGIN TRY 
		SELECT CONCAT('ncc', RIGHT (CONCAT('000', ISNULL(RIGHT(MAX(ma_ncc),3),0) + 1),3))
		FROM NHA_CUNG_CAP WHERE ma_ncc LIKE 'ncc' + '%'
	END TRY
	BEGIN CATCH
		PRINT 'Có lỗi xảy ra'
		PRINT ERROR_MESSAGE()
	END CATCH
END
GO

--HOADON
--TAO HOA DON KHI THANH TOAN
CREATE PROC sp_ThemHoaDon 
	@mahd VARCHAR(10),
	@ngay DATE,
	@tongTien DECIMAL(15,0),
	@giamGia DECIMAL(15,0),
	@sdt VARCHAR(10),
	@manv VARCHAR(10)
AS
BEGIN 
	BEGIN TRY
		BEGIN TRAN insert_HD
		INSERT INTO dbo.HOA_DON VALUES(@mahd, @ngay, @tongTien, @giamGia, DEFAULT, @sdt, @manv)
		COMMIT TRAN insert_HD
	END TRY
	BEGIN CATCH
		PRINT N'Xảy ra lỗi'
		ROLLBACK TRAN insert_HD
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR (@er, 16,1)
	END CATCH
END
GO

--TAO CHI TIET HOA DON KHI THEM HOA DON
CREATE PROC sp_ThemChiTietHD
	@mahd VARCHAR(10),
	@masp VARCHAR(10),
	@sluong INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN insert_CTHD
		INSERT INTO dbo.CHI_TIET_HOA_DON VALUES (@mahd, @masp, @sluong, DEFAULT)
		COMMIT TRAN insert_CTHD
	END TRY
	BEGIN CATCH
		PRINT N'Xảy ra lỗi'
		ROLLBACK TRAN insert_CTHD
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--XOA HOA DON
CREATE PROC sp_XoaHoaDon
	@ma VARCHAR(10)
AS
BEGIN 
	BEGIN TRY 
		BEGIN TRAN  Delete_HD
		UPDATE CHI_TIET_HOA_DON SET tthai_cthd = 0
		WHERE ma_hd = @ma
		UPDATE HOA_DON SET tthai_hd = 0
		WHERE ma_hd = @ma
		COMMIT TRAN Delete_HD
	END TRY
	BEGIN CATCH 
		PRINT N'Không thể xóa hóa đơn'
		ROLLBACK TRAN Delete_HD
	END CATCH
END 
GO

--TẠO MÃ HOA DON TỰ ĐỘNG
CREATE PROC sp_TaoMaHDTuDong 
AS 
BEGIN
	BEGIN TRY 
		SELECT CONCAT('HD', RIGHT (CONCAT('000', ISNULL(RIGHT(MAX(ma_hd),3),0) + 1),3))
		FROM HOA_DON WHERE ma_hd LIKE 'HD' + '%'
	END TRY
	BEGIN CATCH
		PRINT 'Có lỗi xảy ra'
		PRINT ERROR_MESSAGE()
	END CATCH
END
GO

--TAI KHOAN
--TAO TAI KHOAN
CREATE PROC sp_ThemTaiKhoan
	@ten NVARCHAR(50),
	@mkhau VARCHAR(25),
	@ma VARCHAR(10),
	@role BIT
AS
BEGIN 
	BEGIN TRY
		BEGIN TRAN insert_TK
		-- Kiểm tra xem @ten có bắt đầu bằng một ký tự chữ không
		IF ISNULL(PATINDEX('[A-Za-z]%', @ten), 0) = 0
		BEGIN
			-- Nếu không, báo lỗi và hủy bỏ giao dịch
			ROLLBACK TRAN insert_TK
			RAISERROR('Tên người dùng phải bắt đầu bằng một ký tự chữ.', 16, 1)
			RETURN
		END
		INSERT INTO dbo.TAI_KHOAN VALUES(@ten, @mkhau, default, @ma, @role)
		COMMIT TRAN insert_TK
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN insert_TK
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR(@er, 16, 1)
	END CATCH
END 
GO

--CAP NHAT TAI KHOAN
CREATE PROC sp_CapNhatTK
	@tentk VARCHAR(50),
	@mkhau VARCHAR(25)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN Update_TK
		UPDATE TAI_KHOAN SET mkhau = @mkhau
		WHERE tkhoan = @tentk
		COMMIT TRAN Update_TK
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN Update_TK
		DECLARE @er NVARCHAR(MAX)
		SELECT @er = ERROR_MESSAGE()
		RAISERROR(@er, 16, 1)
	END CATCH
END 
GO