--TAI KHOAN
--Lấy tài khoản từ database
CREATE FUNCTION fn_XacThucTaiKhoan (@tkhoan char(50), @mkhau char(25))
RETURNS TABLE
AS
RETURN 
	SELECT	tkhoan, mkhau, ten_nv, tk.ma_nv
	FROM TAI_KHOAN tk INNER JOIN NHAN_VIEN nv ON tk.ma_nv = nv.ma_nv
	WHERE tkhoan = @tkhoan AND mkhau = @mkhau
GO

--KIEM TRA TAIKHOAN CO TON TAI TRONG DATABASE 
CREATE FUNCTION fn_KtraDangNhap(@tkhoan char(50), @mkhau char(25))
RETURNS INT
AS
BEGIN
	DECLARE @result int
	SELECT @result = COUNT(*) --đếm số lượng dòng trong bảng TAI_KHOAN
	FROM TAI_KHOAN
	WHERE tkhoan = @tkhoan AND mkhau = @mkhau
	RETURN @result
END
GO

--TIM KIEM TAIKHOAN THEO MANV
CREATE FUNCTION fn_TimTKTheoMaTK (@ma VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT tk.tkhoan AS "Tên tài khoản",
			tk.mkhau AS "Mật khẩu", 
			tk.ma_nv AS "Mã nhân viên"
	FROM TAI_KHOAN tk
	WHERE tk.ma_nv LIKE '%' + @ma + '%' AND tk.tthai_tk = 1
GO

--TIM KIEM TAIKHOAN THEO TEN
CREATE FUNCTION fn_TimTKTheoTen (@ten VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT tk.tkhoan AS "Tên tài khoản",
			tk.mkhau AS "Mật khẩu", 
			tk.ma_nv AS "Mã nhân viên"
	FROM TAI_KHOAN tk
	WHERE tk.tkhoan LIKE N'%' + @ten + '%' AND tk.tthai_tk = 1
GO 

--SAN PHAM
--TIM KIEM SAN PHAM THEO MASP
CREATE FUNCTION fn_TimSPTheoMaSP(@ma VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT	ma_sp AS "Mã sản phẩm",
			ten_sp AS "Tên sản phẩm",
			gia AS "Giá",
			anh	AS "Hình ảnh",
			kthuoc_sp AS "Kích thước",
			sluong_sp AS "Số lượng"
	FROM SAN_PHAM
	WHERE ma_sp LIKE '%' + @ma + '%' AND tthai_sp = 1
GO

--TIM KIEM SAN PHAM THEO TENSP
CREATE FUNCTION fn_TimSPTheoTen(@ten VARCHAR(225))
RETURNS TABLE
AS
RETURN 
	SELECT	ma_sp AS "Mã sản phẩm",
			ten_sp AS "Tên sản phẩm",
			gia AS "Giá",
			anh	AS "Hình ảnh",
			kthuoc_sp AS "Kích thước",
			sluong_sp AS "Số lượng"
	FROM SAN_PHAM
	WHERE ten_sp LIKE '%' + @ten + '%' AND tthai_sp = 1
GO

--HOA DON
--TIM KIEM HOA DON THEO MAHD
CREATE FUNCTION fn_TimHDTheoMaHD(@ma VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT	hd.ma_hd AS "Mã hóa đơn",
			hd.ngay_xuat AS "Ngày thanh toán",
			hd.tong_tien AS "Tổng thanh toán",
			hd.giam_gia	AS "Giảm giá",
			k.sdt_kh AS "Số điện thoại",
			k.ten_kh AS "Tên khách hàng"
	FROM KHACH_HANG k INNER JOIN HOA_DON hd ON k.sdt_kh = hd.sdt_kh
	WHERE hd.ma_hd LIKE '%' + @ma + '%' AND tthai_hd = 1
GO

--TIM KIEM HOA DON THEO SDT
CREATE FUNCTION fn_TimHDTheoSDT(@sdt VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT	hd.ma_hd AS "Mã hóa đơn",
			hd.ngay_xuat AS "Ngày thanh toán",
			hd.tong_tien AS "Tổng thanh toán",
			hd.giam_gia	AS "Giảm giá",
			k.sdt_kh AS "Số điện thoại",
			k.ten_kh AS "Tên khách hàng"
	FROM KHACH_HANG k INNER JOIN HOA_DON hd ON k.sdt_kh = hd.sdt_kh
	WHERE k.sdt_kh LIKE '%' + @sdt + '%' AND hd.tthai_hd = 1
GO

--TIM KIEM HOA DON THEO MASP
CREATE FUNCTION fn_TimHDTheoMaSP(@ma VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT	hd.ma_hd AS "Mã hóa đơn",
			hd.ngay_xuat AS "Ngày thanh toán",
			hd.tong_tien AS "Tổng thanh toán",
			hd.giam_gia	AS "Giảm giá",
			k.sdt_kh AS "Số điện thoại",
			k.ten_kh AS "Tên khách hàng"
	FROM (KHACH_HANG k INNER JOIN HOA_DON hd ON k.sdt_kh = hd.sdt_kh)
		INNER JOIN CHI_TIET_HOA_DON ct ON ct.ma_hd = hd.ma_hd
	WHERE ct.ma_sp LIKE '%' + @ma + '%' AND hd.tthai_hd = 1
GO

--TIM KIEM HOA DON THEO	NGAY
CREATE FUNCTION fn_TimHDTheoNgay(@ngayBatDau DATE, @ngayKetThuc DATE)
RETURNS TABLE
AS
RETURN 
	SELECT	hd.ma_hd AS "Mã hóa đơn",
			hd.ngay_xuat AS "Ngày thanh toán",
			hd.tong_tien AS "Tổng thanh toán",
			hd.giam_gia	AS "Giảm giá",
			k.sdt_kh AS "Số điện thoại",
			k.ten_kh AS "Tên khách hàng"
	FROM KHACH_HANG k INNER JOIN HOA_DON hd ON k.sdt_kh = hd.sdt_kh
	WHERE hd.ngay_xuat BETWEEN @ngayBatDau AND @ngayKetThuc AND hd.tthai_hd = 1
GO

--KHACH HANG
--TIM KIEM KHACH HANG THEO SDT
CREATE FUNCTION fn_TimKhachHangTheoSdt(@sdt VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT	sdt_kh AS "Số điện thoại",
			ten_kh AS "Tên khách hàng",
			diem_tluy AS "Điểm tích lũy",
			tthai_kh AS "Trạng thái"
	FROM KHACH_HANG
	WHERE sdt_kh = @sdt
GO

--TIM KIEM KHACH HANG THEO TEN
CREATE FUNCTION fn_TimKhachHangTheoTen(@ten VARCHAR(255))
RETURNS TABLE 
AS
RETURN 
	SELECT	sdt_kh AS "Số điện thoại",
			ten_kh AS "Tên khách hàng",
			diem_tluy AS "Điểm tích lũy",
			tthai_kh AS "Trạng thái"
	FROM KHACH_HANG
	WHERE ten_kh LIKE N'%' + @ten + '%'
GO

--NHAN VIEN 
--TIM KIEM NHAN VIEN THEO MANV
CREATE FUNCTION fn_TimNVTheoMa (@ma VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT	nv.ma_nv AS "Mã nhân viên",
			nv.ten_nv AS "Tên nhân viên",
			nv.dchi_nv AS "Địa chỉ",
			nv.sdt_nv AS "Số điện thoại",
			nv.gtinh_nv AS "Giới tính",
			tk.tkhoan AS "Tên tài khoản",
			tk.mkhau AS "Mật khẩu"
	FROM NHAN_VIEN nv INNER JOIN TAI_KHOAN tk ON nv.ma_nv =	tk.ma_nv
	WHERE nv.ma_nv LIKE '%' + @ma + '%' and nv.tthai_nv = 1
GO

--TIM KIEM NHAN VIEN THEO TEN
CREATE FUNCTION fn_TimNVTheoTen (@ten VARCHAR(10))
RETURNS TABLE
AS
RETURN 
	SELECT	nv.ma_nv AS "Mã nhân viên",
			nv.ten_nv AS "Tên nhân viên",
			nv.dchi_nv AS "Địa chỉ",
			nv.sdt_nv AS "Số điện thoại",
			nv.gtinh_nv AS "Giới tính",
			tk.tkhoan AS "Tên tài khoản",
			tk.mkhau AS "Mật khẩu"
	FROM NHAN_VIEN nv INNER JOIN TAI_KHOAN tk ON nv.ma_nv =	tk.ma_nv
	WHERE nv.ten_nv LIKE '%' + @ten + '%' and nv.tthai_nv = 1
GO

--THONG KE 
--TONG TIEN NHAP HANG 
CREATE FUNCTION fn_TinhTienNhapHang (@soNgay INT)
RETURNS DECIMAL(15,0)
AS
BEGIN 
	DECLARE @tongTien DECIMAL(15,0)
	DECLARE @ngayBatDau DATE = DATEADD(DAY, -@soNgay, GETDATE())

	SELECT @tongTien = SUM(ct.gia_nhap*ct.sluong_nhap)
	FROM LO_HANG l JOIN CHI_TIET_LO_HANG ct ON l.ma_lo = ct.ma_lo
	WHERE l.ngay_nhap >= @ngayBatDau;

	RETURN ISNULL(@tongTien, 0)
END
GO 

--TONG TIEN BAN HANG 
CREATE FUNCTION fn_TinhTienBanHang(@soNgay INT)
RETURNS DECIMAL(15,0)
AS
BEGIN 
	DECLARE @tongTien DECIMAL(15,0)
	DECLARE @ngayBatDau DATE = DATEADD(DAY, -@soNgay, GETDATE())

	SELECT @tongTien = SUM(ct.sluong*sp.gia)
	FROM HOA_DON hd INNER JOIN CHI_TIET_HOA_DON ct ON hd.ma_hd = ct.ma_hd
		INNER JOIN SAN_PHAM sp ON ct.ma_sp = sp.ma_sp
	WHERE hd.ngay_xuat >= @ngayBatDau;

	RETURN ISNULL(@tongTien, 0)
END
GO 

--TINH SO KHACH HANG DA MUA
CREATE FUNCTION fn_TinhSoKhachHang()
RETURNS INT
AS
BEGIN 
	DECLARE @ketQua INT
	SELECT @ketQua = COUNT(*) 
	FROM KHACH_HANG 
	WHERE tthai_kh = 1
	RETURN ISNULL(@ketQua, 0)
END 
GO 

--TINH SO SP DA BAN THEO THOI GIAN 
CREATE FUNCTION fn_TinhSoSPDaBan (@soNgay INT)
RETURNS INT
AS 
BEGIN
	DECLARE @ketQua INT
	DECLARE @ngayBatDau DATE = DATEADD(DAY, -@soNgay, GETDATE())

	SELECT @ketQua = SUM(ct.sluong)
	FROM HOA_DON hd INNER JOIN CHI_TIET_HOA_DON ct ON hd.ma_hd = ct.ma_hd
	WHERE hd.ngay_xuat >= @ngayBatDau AND tthai_cthd = 1;

	RETURN ISNULL(@ketQua, 0)
END
GO 

--TIM TOP 10 SP BAN DUOC NHIEU NHAT
CREATE FUNCTION fn_TimTop10SanPham(@soNgay INT)
RETURNS TABLE
AS
RETURN 
	SELECT TOP 10 
		sp.ma_sp AS "Mã sản phẩm", 
		sp.ten_sp AS "Tên sản phẩm", 
		sp.kthuoc_sp AS "Kích thước",
		sp.gia AS "Giá",
		SUM(ct.sluong) SoLuong 
	FROM SAN_PHAM sp INNER JOIN CHI_TIET_HOA_DON ct ON sp.ma_sp = ct.ma_sp
			INNER JOIN HOA_DON hd ON hd.ma_hd = ct.ma_hd
	WHERE hd.ngay_xuat >= DATEADD(DAY, -@soNgay, GETDATE())
	GROUP BY sp.ma_sp, sp.ten_sp, sp.kthuoc_sp, sp.gia
	ORDER BY SoLuong DESC 
GO 