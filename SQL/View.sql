USE QLCUAHANG
GO

--xem cac mat hang hien co
CREATE VIEW v_SanPham
AS
SELECT 
	sp.ma_sp as "Mã mặt hàng",
	sp.ten_sp as "Tên mặt hàng",
	sp.gia as "Giá",
	sp.anh as "Hình ảnh",
	sp.kthuoc_sp as "Kích thước",
	sp.sluong_sp as "Số lượng"
FROM SAN_PHAM sp
WHERE sp.tthai_sp = 1
GO

--Xem thong tin khach hang con hoat dong
CREATE VIEW v_KhachHang
AS
SELECT kh.sdt_kh as "Số điện thoại",
       kh.ten_kh as "Tên khách hàng",
	   kh.diem_tluy as "Điểm tích lũy"
FROM KHACH_HANG kh
WHERE kh.tthai_kh = 1;
GO

--Xem thong tin khach hang khong hoat dong
CREATE VIEW v_KhachHangCu
AS
SELECT kh.sdt_kh as "Số điện thoại",
       kh.ten_kh as "Tên khách hàng",
	   kh.diem_tluy as "Điểm tích lũy"
FROM KHACH_HANG kh
WHERE kh.tthai_kh = 0;
GO

--Xem thong tin nhan vien
CREATE VIEW v_NhanVien
AS
SELECT nv.ma_nv as "Mã nhân viên", 
	   nv.ten_nv as "Tên nhân viên", 
	   nv.dchi_nv as "Địa chỉ", 
	   nv.sdt_nv as "Số điện thoại", 
	   nv.gtinh_nv as "Giới tính"
FROM NHAN_VIEN nv 
WHERE nv.tthai_nv = 1;
GO

--Thong tin tai khoan
CREATE VIEW v_TaiKhoan
AS
SELECT
	tk.tkhoan as "Tài khoản",
	tk.mkhau as "Mật khẩu",
	tk.ma_nv as "Mã nhân viên"
FROM TAI_KHOAN tk 
WHERE tk.tthai_tk = 1

--Xem thông tin người tạo và người mua hóa đơn
CREATE VIEW v_NhanVien_KhachHang
AS
SELECT 
    nv.ten_nv as "Tên nhân viên",
    kh.ten_kh as "Tên khách hàng",
	hd.ngay_xuat as "Ngày thanh toán",
    hd.ma_hd as "Mã hóa đơn"
FROM 
    HOA_DON AS hd
    JOIN NHAN_VIEN nv ON hd.ma_nv = nv.ma_nv
    JOIN KHACH_HANG kh ON hd.sdt_kh = kh.sdt_kh;
GO
	
--Xem thong tin hoa don
CREATE VIEW v_HoaDon
AS
SELECT hd.ma_hd as "Mã hóa đơn", 
	 hd.ngay_xuat as "Ngày thanh toán",
	 hd.tong_tien as "Tổng thanh toán",
	 hd.giam_gia as "Giảm giá",
	 kh.sdt_kh as "Số điện thoại",
	 kh.ten_kh as "Tên khách hàng"
FROM KHACH_HANG kh INNER JOIN HOA_DON hd
	ON kh.sdt_kh = hd.sdt_kh
WHERE hd.tthai_hd = 1
GO

--Xem chi tiet hoa don
CREATE VIEW v_ChiTietHoaDon
AS
SELECT 	hd.ma_hd as "Mã hóa đơn",
	sp.ma_sp as "Mã mặt hàng",
	sp.ten_sp as "Tên sản phẩm",
	sp.gia as "Giá",
	cthd.sluong as "Số lượng",
	cthd.sluong * sp.gia  as "Thành tiền"
FROM (CHI_TIET_HOA_DON cthd INNER JOIN SAN_PHAM sp ON cthd.ma_sp = sp.ma_sp) 
	INNER JOIN HOA_DON hd ON hd.ma_hd = cthd.ma_hd
WHERE hd.tthai_hd = 1
GO
CREATE VIEW V_INFO_DETAIL_BILL
AS
SELECT 	b.b_id as "Mã hóa đơn",
	p.p_id as "Mã mặt hàng",
	p.p_name as "Tên sản phẩm",
	p.p_price as "Giá",
	d.db_quantity as "Số lượng",
	d.db_quantity * p.p_price  as "Thành tiền"
FROM (DETAIL_BILL d INNER JOIN PRODUCT p ON d.p_id = p.p_id) INNER JOIN BILL b ON b.b_id = d.b_id
WHERE b.b_status = 1

--Xem so luong mat hang ban duoc
CREATE VIEW v_SoSanPhamDaBan 
AS
SELECT sp.ma_sp as "Mã mặt hàng",
       sp.ten_sp as "Tên mặt hàng",
	   sp.kthuoc_sp as "Kích thước",
       SUM(cthd.sluong) as "Số lượng đã bán"
FROM SAN_PHAM sp INNER JOIN CHI_TIET_HOA_DON cthd 
	ON sp.ma_sp = cthd.ma_sp
WHERE cthd.tthai_cthd = 1
GROUP BY sp.ma_sp, sp.ten_sp, sp.kthuoc_sp;
GO

--Xem chi tiet mat hang ban duoc trong ngay
CREATE VIEW v_SanPhamTheoNgay 
AS
SELECT
    sp.ma_sp AS "Mã sản phẩm",
    sp.ten_sp AS "Tên sản phẩm",
    sp.gia AS "Giá sản phẩm",
    cthd.sluong AS "Số lượng bán",
    hd.ngay_xuat AS "Ngày bán"
FROM CHI_TIET_HOA_DON cthd INNER JOIN HOA_DON hd ON cthd.ma_hd = hd.ma_hd
					INNER JOIN SAN_PHAM sp ON cthd.ma_sp = sp.ma_sp
WHERE hd.tthai_hd = 1
GO

--Xem thong tin lo hang va nha cung cap
CREATE VIEW v_LoHang_NhaCungCap
AS
SELECT ncc.ma_ncc as "Mã nhà cung cấp",
	 ncc.ten_ncc as "Tên nhà cung cấp",
	 ncc.sdt_ncc as "Số điện thoại",
	 ncc.dchi_ncc as "Địa chỉ",
	 lh.ma_lo as "Mã lô hàng",
	 lh.ngay_nhap as "Ngày nhập"
FROM LO_HANG lh INNER JOIN NHA_CUNG_CAP ncc 
	ON lh.ma_ncc = ncc.ma_ncc
WHERE lh.tthai_lo=1;
GO

--Xem chi tiet lo hang
CREATE VIEW v_ChiTietLoHang
AS
SELECT lh.ma_lo as "Mã lô hàng",
	 sp.ma_sp as "Mã mặt hàng",
	 sp.ten_sp as "Tên mặt hàng",
	 sp.kthuoc_sp as "Kích thước",
	 sp.gia as "Giá nhập",
	 ct.sluong_nhap as "Số lượng"
FROM LO_HANG lh INNER JOIN CHI_TIET_LO_HANG ct ON lh.ma_lo = ct.ma_lo
			INNER JOIN SAN_PHAM sp ON ct.ma_sp = sp.ma_sp
WHERE lh.tthai_lo=1;
GO

--Xem thong tin nha cung cap
CREATE VIEW v_NhaCungCap 
AS
SELECT ncc.ma_ncc as "Mã nhà cung cấp",
	 ncc.ten_ncc as "Tên nhà cung cấp",
	 ncc.sdt_ncc as "Số điện thoại",
	 ncc.dchi_ncc as "Địa chỉ"
FROM NHA_CUNG_CAP ncc 
WHERE ncc.tthai_ncc=1;
GO