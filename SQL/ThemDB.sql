USE QLCUAHANG
GO 

INSERT INTO KHACH_HANG (sdt_kh, ten_kh, diem_tluy, tthai_kh)
VALUES 
	('0963331888', 'Nguyen Van Anh', 100, 1),
    ('0987654321', 'Tran Thi Huong',  50, 1),
    ('0987645635', 'Tran Thi Diem',  50, 1),
    ('0987656734', 'Tran Thi Chau',  50, 1),
    ('0987656456', 'Tran Thi Suong',  50, 1),
    ('0987687578', 'Tran Thi Sa',  50, 1),
    ('0967589321', 'Tran Thi Binh', 50, 1),
    ('0987678234', 'Tran Thi Tu',  50, 1),
    ('0987973451', 'Tran Thi Lan',  50, 1),
    ('0987697456', 'Tran Thi Huong',  50, 1),
    ('0987988901', 'Tran Thi Hoa',  50, 1),
    ('0987564731', 'Tran Thi My', 50, 1),
    ('0987654569', 'Tran Thi Chieu',  50, 1),
    ('0987898761', 'Tran Thi Chinh', 50, 1);

INSERT INTO NHAN_VIEN (ma_nv, ten_nv, dchi_nv, sdt_nv, gtinh_nv, tthai_nv)
VALUES 
	('nv001', 'Tran Thi Thao Ly', 'Thu Duc', '0366829754', 'Nu', 1)

INSERT INTO TAI_KHOAN (tkhoan, mkhau, tthai_tk, ma_nv)
VALUES 
	('ly', '123', default, 'nv001')

INSERT INTO NHA_CUNG_CAP (ma_ncc, ten_ncc, sdt_ncc, dchi_ncc,tthai_ncc)
VALUES 
	('ncc001', 'Nha cung cap X', '0963647486', '23 Vo Van Ngan', 1),
    ('ncc002', 'Nha cung cap Y', '0967835657', '102 Vo Van Ngan', 1),
    ('ncc003', 'Nha cung cap Z', '0967835688', '34 To Vinh Dien', 1),
    ('ncc004', 'Nha cung cap W', '0975673435', '45 Hoang Dieu 2', 1);