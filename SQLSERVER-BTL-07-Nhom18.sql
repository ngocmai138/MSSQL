use QLCH_MayTinh
drop database QlyNhapHang

--Câu 1. Xác định các bảng và Tạo CSDL của bài toán
-- Tạo và sử dụng csdl
create database QlyNhapHang
on(name = QLNhapHang_Data,
filename='F:\Downloads\Github projects\MSSQL\SQLSERVER-BTL-07-Nhom18.mdf',
size=4MB,
maxsize=10MB,
filegrowth=10%)

use QlyNhapHang

-- Tạo bảng
create table tblSanPham(
sMaSP nvarchar(10) primary key,
sTenSP nvarchar(30),
fGiaban float,
fSoluongtonkho float,
sDonvitinh nvarchar(10)
);

create table tblNhanVien(
sMaNV nvarchar(10) primary key,
sTenNV nvarchar(30),
sDiachi nvarchar(50),
sDienthoai nvarchar(12),
dNgaysinh datetime,
bGioitinh bit,
fLuong float
);

create table tblNhaCC(
sMaNCC nvarchar(10) primary key,
sTenNCC nvarchar(50),
sDiachi nvarchar(50),
sDienthoai nvarchar(12)
);

create table tblPhieuNhap(
sMaPN nvarchar(10) primary key,
sMaNV nvarchar(10),
sMaNCC nvarchar(10),
dNgaynhaphang datetime
);

create table tblCTPhieuNhap(
sMaPN nvarchar(10),
sMaSP nvarchar(10) references tblSanPham(sMaSP),
fGianhap float,
fSoluongnhap float,
constraint PK_CTNSP primary key (sMaPN, sMaSP)
);

-- Chèn dữ liệu cho bảng
insert into tblSanPham 
values('SP001',N'Bút bi xanh',2000,100,N'Cây'),
('SP002',N'Bút bi đỏ',2000,150,N'Cây'),
('SP003',N'Bút chì cây 2B',1000,50,N'Cây'),
('SP004',N'Tẩy bút chì',3000,40,N'Cái'),
('SP005',N'Thước kẻ 20cm',5000,80,N'Cái');
select*from tblSanPham;

insert into tblNhanVien
values('NV001',N'Nguyễn Văn Hưng',N'Số 1, Ngõ 1, Đường 1, Quận 1','0987654321','01/01/1990',1,5000000),
('NV002',N'Trần Thị Mến',N'Số 2, Ngõ 2, Đường 2, Quận 2','0123456789','02/02/1991',0,8000000),
('NV003',N'Lê Văn Cận',N'Số 3, Ngõ 3, Đường 3, Quận 3','0912345678','03/03/1992',1,7300000),
('NV004',N'Phạm Thị Liễu',N'Số 4, Ngõ 4, Đường 4, Quận 4','0901234567','04/04/1993',0,12000000),
('NV005',N'Hoàng Văn Thy',N'Số 5, Ngõ 5, Đường 5, Quận 5','0981234567','05/05/1994',1,4000000);
selecT*from tblNhanVien;

insert into tblNhaCC
values('NCC001',N'Công ty TNHH ABC',N'Số 6, Ngõ 6, Đường 6, Quận 6','02412345678'),
('NCC002',N'Công ty CP XYZ',N'Số 7, Ngõ 7, Đường 7, Quận 7','02487654321'),
('NCC003',N'Công ty TNHH MNP',N'Số 8, Ngõ 8, Đường 8, Quận 8','02413579246'),
('NCC004',N'Công ty CP QRS',N'Số 9, Ngõ 9, Đường 9, Quận 9','02424680135'),
('NCC005',N'Công ty TNHH TUV',N'Số 10, Ngõ 10, Đường 10, Quận 10','02435791368');
select*from tblNhaCC;

insert into tblPhieuNhap
values('PN001','NV001','NCC001','01/10/2023'),
('PN002','NV002','NCC002','02/9/2023'),
('PN003','NV003','NCC003','03/11/2023'),
('PN004','NV004','NCC004','04/12/2023'),
('PN005','NV005','NCC005','05/8/2023');
select*from tblPhieuNhap;

insert into tblCTPhieuNhap
values('PN001','SP001',1500,20),
('PN001','SP002',1500,10),
('PN001','SP003',800,30),
('PN002','SP004',2500,15),
('PN002','SP005',4000,10),
('PN003','SP001',1500,25),
('PN003','SP002',1500,15),
('PN003','SP003',800,35),
('PN004','SP004',2500,20),
('PN004','SP005',4000,15),
('PN005','SP001',1500,30),
('PN005','SP002',1500,20),
('PN005','SP003',800,40);
select*from tblCTPhieuNhap;

--Câu 2: Tạo các view chứa và khai thác CSDL
-- 2.1. View chứa thông tin mã sản phẩm, tên sản phẩm, số lượng tồn kho
create view vThongtinSP
as
select sMaSP, sTenSP, fSoluongtonkho
from tblSanPham;
select*from vThongtinSP;

-- 2.2. View chứa thông tin các nhân viên có lương lớn hơn 7.000.000
create view vThongtinNV
as
select *
from tblNhanVien
where fLuong > 7000000;
select*from vThongtinNV;

-- 2.3. View chứa thông tin tên các sản phẩm, đơn vị tính, tổng tiền nhập có đơn vị tính là "cây"
create view vThongtinSP_DVT
as
select sTenSP, sDonvitinh, sum(fGianhap*fSoluongnhap) as [Tổng tiền]
from tblSanPham,tblCTPhieuNhap
where sDonvitinh in (N'Cây') and tblSanPham.sMaSP = tblCTPhieuNhap.sMaSP
group by sTenSP;
select * from vThongtinSP_DVT;

-- 2.4. View chứa thông tin mã phiếu nhập, tên nhân viên và tên nhà cung cấp nhập hàng trong tháng 3-2023
create view vThongtinPN_NV_NCC
as
select PN.sMaPN, NV.sTenNV, NCC.sTenNCC
from tblPhieuNhap PN
join tblNhanVien NV
on PN.sMaNV = NV.sMaNV
join tblNhaCC NCC
on PN.sMaNCC = NCC.sMaNCC
where month(PN.dNgaynhaphang)=3;
select * from vThongtinPN_NV_NCC;

-- 2.5. View chứa thông tin tên sản phẩm, tên nhà cung cấp với phiếu nhập có tổng tiền lớn hơn 40.000
create view vThongtinPN_SP_NCC
as
select SP.sTenSP, NCC.sTenNCC, sum(CTPN.fGianhap*CTPN.fSoluongnhap) as[Tổng tiền]
from tblSanPham SP, tblNhaCC NCC, tblCTPhieuNhap CTPN, tblPhieuNhap PN
where CTPN.sMaSP = SP.sMaSP and PN.sMaNCC = NCC.sMaNCC and CTPN.sMaPN = PN.sMaPN
group by sTenSP, sTenNCC
having sum(CTPN.fGianhap*CTPN.fSoluongnhap) > 40000;
select * from vThongtinPN_SP_NCC;
-- 2.6. View chứa thông tin thống kê số lượng nhân viên theo giới tính
-- 2.7. View chứa thông tin mã phiếu nhập, tên sản phẩm, số lượng, đơn giá, thành tiền
-- 2.8. View chứa thông tin mã sản phẩm, tên sản phẩm, tổng số lượng, tổng thành tiền nhập vào
-- 2.9. View chứa thông tin mã nhà cung cấp, tên nhà cung cấp, tổng số lượng, tổng thành tiền
-- 2.10. View chứa thông tin tên nhân viên, số điện thoại, thời gian nhập hàng trong tháng 2/2023 - 4/2023, tên sản phẩm, số lượng nhập >20