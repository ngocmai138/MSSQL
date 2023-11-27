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
sGioitinh nvarchar(10),
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
('SP005',N'Thước kẻ 20cm',5000,80,N'Cái'),
('SP007',N'Kéo thủ công',9000,0,N'Cái'),
('SP008',N'Bút chì màu',30000,10,N'Hộp');
select*from tblSanPham;

delete from tblNhanVien
insert into tblNhanVien
values('NV001',N'Nguyễn Văn Hưng',N'Số 1, Ngõ 1, Đường 1, Quận 1','0987654321','01/01/1990',N'Nam',5000000),
('NV002',N'Trần Thị Mến',N'Số 2, Ngõ 2, Đường 2, Quận 2','0123456789','02/02/1991',N'Nữ',8000000),
('NV003',N'Lê Văn Cận',N'Số 3, Ngõ 3, Đường 3, Quận 3','0912345678','03/03/1992',N'Nam',7300000),
('NV004',N'Phạm Thị Liễu',N'Số 4, Ngõ 4, Đường 4, Quận 4','0901234567','04/04/1993',N'Nữ',12000000),
('NV005',N'Hoàng Văn Thy',N'Số 5, Ngõ 5, Đường 5, Quận 5','0981234567','05/05/1994',N'Nam',4000000);
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

-- 2.3. View chứa thông tin mã phiếu nhập, tên sản phẩm, số lượng, đơn giá, thành tiền
create view vThongtinCTPN_SP
as
select CTPN.sMaPN, SP.sTenSP, CTPN.fSoluongnhap, CTPN.fGianhap, fGianhap*fSoluongnhap as 'Thành tiền'
from tblCTPhieuNhap CTPN, tblSanPham SP
where CTPN.sMaSP = SP.sMaSP;
select * from vThongtinCTPN_SP;

-- 2.4. View chứa thông tin tên các sản phẩm, đơn vị tính, tổng tiền nhập có đơn vị tính là "cây"
create view vThongtinSP_DVT
as
select sTenSP, sum(fGianhap*fSoluongnhap) as [Tổng tiền]
from tblSanPham SP,tblCTPhieuNhap PN
where sDonvitinh in (N'Cây') and SP.sMaSP = PN.sMaSP
group by sTenSP;
select * from vThongtinSP_DVT;

-- 2.5. View chứa thông tin mã phiếu nhập, tên nhân viên và tên nhà cung cấp nhập hàng trong tháng 3-2023
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

-- 2.6. View chứa thông tin tên sản phẩm, tên nhà cung cấp với phiếu nhập có tổng tiền nhập lớn hơn 40.000
create view vThongtinPN_SP_NCC
as
select SP.sTenSP, NCC.sTenNCC, sum(CTPN.fGianhap*CTPN.fSoluongnhap) as[Tổng tiền nhập]
from tblSanPham SP, tblNhaCC NCC, tblCTPhieuNhap CTPN, tblPhieuNhap PN
where CTPN.sMaSP = SP.sMaSP and PN.sMaNCC = NCC.sMaNCC and CTPN.sMaPN = PN.sMaPN
group by sTenSP, sTenNCC
having sum(CTPN.fGianhap*CTPN.fSoluongnhap) > 40000;
select * from vThongtinPN_SP_NCC;

-- 2.7. View chứa thông tin thống kê số lượng nhân viên theo giới tính
create view vThongtinTK_GTNV
as
select sGioitinh as 'Giới tính', COUNT(sMaNV) as 'Số lượng'
from tblNhanVien
group by sGioitinh;
select * from vThongtinTK_GTNV;

-- 2.8. View chứa thông tin mã sản phẩm, tên sản phẩm, tổng số lượng, tổng thành tiền nhập vào
create view vThongkeSP
as
select SP.sMaSP, sTenSP, sum(CTPN.fSoluongnhap) as 'Tổng số lượng', sum(CTPN.fSoluongnhap*CTPN.fGianhap) as 'Tổng thành tiền'
from tblSanPham SP 
join tblCTPhieuNhap CTPN
on SP.sMaSP = CTPN.sMaSP
group by SP.sMaSP, SP.sTenSP;
select * from vThongkeSP;

-- 2.9. View chứa thông tin mã nhà cung cấp, tên nhà cung cấp, tổng số lượng, tổng thành tiền
create view vThongkeNCC
as
select PN.sMaNCC, NCC.sTenNCC, sum(fSoluongnhap) 'Tổng số lượng', sum(fSoluongnhap*fGianhap) as 'Tổng thành tiền'
from tblNhaCC NCC, tblCTPhieuNhap CTPN, tblPhieuNhap PN
where PN.sMaNCC = NCC.sMaNCC 
and PN.sMaPN = CTPN.sMaPN
group by PN.sMaNCC, NCC.sTenNCC;
select * from vThongkeNCC;

-- 2.10. View chứa thông tin tên nhân viên, số điện thoại, thời gian nhập hàng trong tháng 2/2023 - 4/2023, tên sản phẩm, số lượng nhập >20
create view vThongkeNV_Ngaynhap
as
select NV.sTenNV, NV.sDienthoai, PN.dNgaynhaphang, SP.sTenSP, CTPN.fSoluongnhap as 'Số lượng nhập'
from tblNhanVien NV
join tblPhieuNhap PN
on NV.sMaNV = PN.sMaNV
join tblCTPhieuNhap CTPN
on PN.sMaPN = CTPN.sMaPN
join tblSanPham SP
on CTPN.sMaSP = SP.sMaSP
where year(PN.dNgaynhaphang)=2023 and  month(PN.dNgaynhaphang) in (2,3,4)
group by NV.sTenNV, NV.sDienthoai, SP.sTenSP, PN.dNgaynhaphang, CTPN.fSoluongnhap
having sum(fSoluongnhap)>20;
select * from vThongkeNV_Ngaynhap;

--Câu 3: Tạo và thực thi các thủ tục cho CSDL 
-- 3.1. Thêm sản phẩm mới vào bảng sản phẩm
create proc ThemSP
@sMaSP nvarchar(10), @sTenSP nvarchar(30), @fGiaban nvarchar(10), @fSoluong float, @sDonvitinh nvarchar(10)
as
if exists(select * from tblSanPham where tblSanPham.sMaSP=@sMaSP)
print(N'Đã tồn tại sản phẩm có mã vừa nhập vào')
else
begin
insert into tblSanPham values 
(@sMaSP, @sTenSP,@fGiaban,@fSoluong,@sDonvitinh)
end;

exec ThemSP 'SP006',N'Băng dính',4000,50,N'Cuộn';
select * from tblSanPham;

-- 3.2. Nhập vào Mã phiếu nhập, tính tổng tiền đã mua hàng
create proc TongtienPN
@sMaPN nvarchar(10)
as
begin
if exists(select * from tblPhieuNhap where tblPhieuNhap.sMaPN = @sMaPN)
select PN.sMaPN, sum(CTPN.fSoluongnhap*CTPN.fGianhap) as 'Tổng tiền'
from tblCTPhieuNhap CTPN, tblPhieuNhap PN
where PN.sMaPN = CTPN.sMaPN
and PN.sMaPN=@sMaPN
group by PN.sMaPN
else print(N'Mã phiếu nhập không tồn tại')
end;

exec TongtienPN 'PN002';

-- 3.3. Hiển thị sản phẩm không được mua theo tháng
create proc SPkhongduocmua
@Month int
as
select * from tblSanPham
where tblSanPham.sMaSP
not in
(select ctpn.sMaSP
from tblCTPhieuNhap ctpn, tblPhieuNhap pn
where ctpn.sMaPN = pn.sMaPN
and month(dNgaynhaphang)=@Month);
execute SPkhongduocmua 4;

-- 3.4. Thống kê số sản phẩm được bán với tham số truyền vào là mã sản phẩm
create proc SPduocban
@sMaSPduocban nvarchar(10)
as
if not exists(select*from tblSanPham where tblSanPham.sMaSP = @sMaSPduocban)
print (N'Mã sản phẩm không tồn tại')
else
select SP.sMaSP, sTenSP, sum(CTPN.fSoluongnhap) as 'Tổng số lượng đã nhập' 
from tblSanPham SP
join tblCTPhieuNhap CTPN
on SP.sMaSP = CTPN.sMaSP
where SP.sMaSP = @sMaSPduocban
group by SP.sMaSP, sTenSP;

execute SPduocban 'SP004';

-- 3.5. Cho biết SP được nhập từ 1 nhà cung cấp trong 1 năm nào đó có tham số là tên NCC và năm
create proc NCC_nam
@sTenNCC nvarchar(50), @iNamnhap int
as
if not exists (select * from tblNhaCC where sTenNCC = @sTenNCC)
print N'Tên nhà cung cấp không tồn tại'
else
select sp.sMaSP, sTenSP, ncc.sTenNCC, @iNamnhap as 'Năm nhập hàng', sum(ctpn.fSoluongnhap) as 'Số lượng nhập'
from tblSanPham sp
join tblCTPhieuNhap ctpn
on sp.sMaSP = ctpn.sMaSP
join tblPhieuNhap pn
on ctpn.sMaPN = pn.sMaPN
join tblNhaCC ncc
on pn.sMaNCC = ncc.sMaNCC
where ncc.sTenNCC = @sTenNCC 
and year(pn.dNgaynhaphang) = @iNamnhap
group by sp.sMaSP, sTenSP, ncc.sTenNCC;

execute NCC_nam 'abba', 2023;
execute NCC_nam 'Công ty TNHH ABC', 2023;

-- 3.6. Tính tổng tiền nhập hàng trong năm
drop proc Tongtien_bantrongnam
create proc Tongtien_bantrongnam @nam int
as
begin
select year(dNgaynhaphang) as 'Năm', sum(fGianhap*fSoluongnhap) as 'Tổng số tiền nhập hàng' 
from tblPhieuNhap pn, tblCTPhieuNhap ctpn
where pn.sMaPN = ctpn.sMaPN and year(dNgaynhaphang) = @nam
group by year(dNgaynhaphang)
end;

execute Tongtien_bantrongnam 2023;

--Câu 4. Tạo và vận dụng các trigger
-- 4.1. Nhân viên làm việc phải đảm bảo trên 18 tuổi
drop trigger nv_tuoi
create trigger nv_tuoi
on tblNhanVien
instead of insert
as
begin
begin try
	declare @tuoi as int;
	select @tuoi = year(getdate()) - year((select dNgaysinh from inserted));
	if(@tuoi<18)
		begin 
		raiserror (N'Tuổi của nhân viên chưa đủ 18',16,10);
		end;
	else
		begin
		insert into tblNhanVien select * from inserted;
		end;
end try
begin catch
	raiserror (N'Tuổi của nhân viên chưa đủ 18',16,10);
	select ERROR_MESSAGE() as ErrorMessage;
	rollback tran;
end catch

/*
	set xact_abort off;
	declare @tuoi as int;
	select @tuoi = year(getdate()) - year((select dNgaysinh from inserted));
	if(@tuoi<18)
		begin 
		raiserror (N'Tuổi của nhân viên chưa đủ 18',16,10);
		if(@@TRANCOUNT >0)
		rollback tran;
		end
	else
		begin
		insert into tblNhanVien select * from inserted;
		if(@@TRANCOUNT >0)
		commit tran;
		end
		*/
end;

insert into tblNhanVien values('NV006',N'Lý Thị Hảo',N'Số 6, Ngõ 6, Đường 6, Quận 6','0987654321','01/01/2012',N'Nữ',5000000);
insert into tblNhanVien values('NV006',N'Lý Thị Hảo',N'Số 6, Ngõ 6, Đường 6, Quận 6','0987654321','01/01/2002',N'Nữ',5000000);
select *from tblNhanVien

-- 4.2. Đơn giá nhập của mặt hàng phải đảm bảo thấp hơn so với giá bán đã nhập
drop trigger giaban_giagoc
create trigger giaban_giagoc
on tblCTPhieuNhap
instead of insert
as
begin
begin try
declare @sMaSP as nvarchar(10)
declare @fGianhap as float
declare @fGiaban as float
select @sMaSP = (select sMaSP from inserted), @fGianhap = (select fGianhap from inserted)
if not exists (select * from tblCTPhieuNhap where sMaSP=@sMaSP)
	begin 
	raiserror(N'Mã sản phẩm không tồn tại',16,10)
	end
else
	begin
	select @fGiaban = (select fGiaban from tblSanPham where sMaSP = @sMaSP)
	if(@fGianhap > @fGiaban)
		begin
		raiserror(N'Giá nhập cao hơn giá bán',16,11)
		end
	else
		begin
		insert into tblCTPhieuNhap select * from inserted;	
		end
	end
end try
begin catch
	raiserror(N'Mã sản phẩm không tồn tại hoặc giá nhập cao hơn giá bán',16,10)
	rollback tran;
end catch;
end;

insert into tblCTPhieuNhap values('PN005','SP004',5500,20);
insert into tblCTPhieuNhap values('PN005','SP004',1000,20);
select * from tblCTPhieuNhap

-- 4.3. Khi xóa một mặt hàng nào đó thì không cho phép xóa nếu số lượng tồn kho lớn hơn 0
drop trigger SP_Xoa
create trigger SP_Xoa
on tblSanPham
instead of delete
as
begin
begin try
declare @sMaSP as nvarchar(10)
select @sMaSP = (select sMaSP from deleted)
if((select fSoluongtonkho from tblSanPham where sMaSP=@sMaSP)>0)
	begin
	raiserror(N'Số hàng tồn kho > 0',16,10)
	end
else
	begin
	delete from tblSanPham where sMaSP = @sMaSP
	end
end try
begin catch
	raiserror(N'Số hàng tồn kho > 0',16,10)
	rollback tran;
end catch
end;

select * from tblSanPham;
delete from tblSanPham where sMaSP = 'SP007';
delete from tblSanPham where sMaSP = 'SP008';

-- 4.4. Tự động cập nhật số lượng tồn kho cho một sản phẩm khi có một phiếu nhập hàng chứa sản phẩm được thêm vào bảng chi tiết phiếu nhập
drop trigger SP_Soluonghangtonkho
create trigger SP_Soluonghangtonkho
on tblCTPhieuNhap
after insert
as
begin
	update tblSanPham set fSoluongtonkho = fSoluongtonkho + i.fSoluongnhap
	from tblSanPham sp, inserted i
	where sp.sMaSP = i.sMaSP
end;

select * from tblCTPhieuNhap;
select * from tblSanPham;
insert into tblCTPhieuNhap values ('PN002','SP001',1500,50);

-- 4.5. Tự động xóa bản ghi trong tblPhieuNhap khi không có bản ghi nào trong tblCTPhieuNhap có cùng mã phiếu nhập
create trigger PhieuNhap_Xoa
on tblCTPhieuNhap
after delete
as
begin
delete from tblPhieuNhap
where sMaPN not in (select sMaPN from tblCTPhieuNhap)
end

insert into tblCTPhieuNhap values('PN006','SP001',1500,10)
insert into tblPhieuNhap values('PN006','NV005','NCC001','09-3-2022')

delete from tblCTPhieuNhap where sMaPN='PN006'

select*from tblPhieuNhap

--Câu 5. Phân quyền và bảo mật cho CSDL
-- Tạo người dùng
create login User1 with password='123';
create user User1 for login User1;

create login User2 with password = '456';
create user User2 for login User2;

-- Phân quyền cho bảng
grant select, insert, update, delete on tblSanPham to User1;
grant select, insert, update, delete on tblNhanVien to User1;
grant select, insert, update, delete on tblNhaCC to User1;
grant select, insert, update, delete on tblPhieuNhap to User1;
grant select, insert, update, delete on tblCTPhieuNhap to User1;

grant select, insert, update, delete on tblSanPham to User2;
grant select on tblNhanVien to User2;
grant select on tblNhaCC to User2;
grant select on tblPhieuNhap to User2;
grant select on tblCTPhieuNhap to User2;

-- Phân quyền cho view
grant select on vThongtinSP to User1;
grant select on vThongtinSP to User2;
grant select on vThongtinNV to User2;
grant select on vThongtinCTPN_SP to User2;
grant select on vThongtinSP_DVT to User2;
grant select on vThongtinPN_NV_NCC to User2;
grant select on vThongtinPN_SP_NCC to User2;
grant select on vThongtinTK_GTNV to User2;
grant select on vThongkeSP to User2;
grant select on vThongkeNCC to User2;
grant select on vThongkeNV_Ngaynhap to User2;


-- Phân quyền cho procedure
grant execute on ThemSP to User1;
grant execute on TongtienPN to User1;
grant execute on SPkhongduocmua to User2;
grant execute on SPduocban to User2;
grant execute on NCC_nam to User2;

-- Câu 6. Phân tán
