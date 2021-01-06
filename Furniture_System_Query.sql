create database FurnitureDB;
use FurnitureDB;

create table Customer (
NIC varchar(12) primary key not null constraint ck_NIC check((len(NIC)=10 and (NIC) like '%V') or len(NIC)=12),
Fname char(15) not null,
Lname char(20) not null,
AdrsL1 varchar(40) not null,
AdrsL2 varchar(40) not null,
AdrsL3 varchar(40),
);

create table Customer_Nos (
C_ID varchar(12) not null constraint fk_C_ID foreign key (C_ID) references Customer(NIC),
Customer_No char(10) not null,
primary key(C_ID)
);

create table Item(
Item_Code varchar(10) primary key not null,
Item_Name varchar(20) not null,
Price decimal(8,2) not null
);

create table Full_Receipt(
Receipt_No varchar(12) primary key not null,
Total_Amount decimal(8,2) not null,
Payment_Type char(12) not null constraint ck_Payment_Type check(Payment_Type like 'Full Payment'),
Discount int,
Date date default getdate() not null,
Cus_ID varchar(12) not null constraint fk_Cus_ID foreign key (Cus_ID) references Customer(NIC),
Full_SM varchar(12) not null constraint fk_Full_SM foreign key (Full_SM) references Salesman(Salesman_ID)
);

create table Item_Bought_Full(
Item_Bought_No_Full int identity primary key not null,
Rcpt_No varchar(12) not null constraint fk_Rcpt_No foreign key (Rcpt_No) references Full_Receipt(Receipt_No),
FCus_ID varchar(12) not null constraint fk_FCus_ID foreign key (FCus_ID) references Customer(NIC),
FItm_Code varchar(10) not null constraint fk_FItm_Code foreign key (FItm_Code) references Item(Item_Code),
FQuantity int not null,
FUnit_Price decimal(8,2) not null,
);

create table Installment_Receipt(
Receipt_No varchar(12) primary key not null,
Total_Amount decimal(8,2) not null,
Payment_Type char(19) not null constraint ck_Payment_Type_IR check(Payment_Type like 'Installment Payment'),
Date date default getdate() not null,
Cust_ID varchar(12) not null constraint fk_Cust_ID foreign key (Cust_ID) references Customer(NIC),
Ins_SM varchar(12) not null constraint fk_Ins_SM foreign key (Ins_SM) references Salesman(Salesman_ID)
);

create table Item_Bought_Ins(
Item_Bought_No_Ins int identity primary key not null,
Rcipt_No varchar(12) not null constraint fk_Rcipt_No foreign key (Rcipt_No) references Installment_Receipt(Receipt_No),
ICus_ID varchar(12) not null constraint fk_ICus_ID foreign key (ICus_ID) references Customer(NIC),
IItm_Code varchar(10) not null constraint fk_IItm_Code foreign key (IItm_Code) references Item(Item_Code),
Downpayment decimal(8,2) not null,
No_of_Installments int not null,
IQuantity int not null,
IUnit_Price decimal(8,2) not null,
);

create table Installment_Date(
Installment_Date_No int identity primary key not null,
Rec_No varchar(12) not null constraint fk_Rec_No foreign key(Rec_No) references Installment_Receipt(Receipt_No),
InItm_Code varchar(12) not null,
Installment_Date date not null,
Installment_Amount decimal(8,2) not null,
Status char(10) not null constraint ck_Status check(Status like 'Paid' or Status like 'Not Paid'),
SM_ID varchar(12) constraint fk_SM_ID foreign key (SM_ID) references Salesman(Salesman_ID)
);

create table Salesman(
Salesman_ID varchar(12) primary key not null,
Fname char(15) not null,
Lname char(20) not null,
NIC varchar(12) not null constraint ck_NIC_SM check((len(NIC)=10 and (NIC) like '%V') or len(NIC)=12),
Ac_Type varchar(23) not null constraint ck_Ac_Type check (Ac_Type like 'Recovery Officer' or Ac_Type like 'Salesman Officer' or Ac_Type like 'Outlet Salesman Officer')
); 

create table Salesman_Nos (
S_ID varchar(12) not null constraint fk_S_ID foreign key(S_ID) references Salesman(Salesman_ID),
Contact_No char(10) not null,
primary key (S_ID)
);

create table Store(
Store_No varchar(5) primary key not null,
Store_Name varchar(20) not null
);

create table Store_Items(
Stor_ID varchar(5) not null constraint fk_Stor_ID foreign key(Stor_ID) references Store(Store_No),
Item_CD varchar(10) not null constraint fk_Item_CD foreign key(Item_CD) references Item(Item_Code),
Quantity int not null,
primary key(Stor_ID,Item_CD)
);

create table Load(
Load_No varchar(10) primary key not null,
St_ID varchar(5) not null constraint fk_St_ID foreign key(St_ID) references Store(Store_No),
);

create table Load_Items(
L_ID varchar(10) not null constraint fk_L_ID foreign key(L_ID) references Load(Load_No),
Itm_ID varchar(10) not null constraint fk_Itm_ID foreign key(Itm_ID) references Item(Item_Code),
Quantity int not null
primary key(L_ID,Itm_ID)
);

create table Outlet(
Outlet_No varchar(10) primary key not null,
Outlet_Name varchar(20) not null,
AdrsL1 varchar(40) not null,
AdrsL2 varchar(40) not null,
AdrsL3 varchar(40),
Str_ID varchar(5) not null constraint fk_Str_ID foreign key (Str_ID) references Store(Store_No)
);

create table Outlet_Contact_No(
O_No varchar(10) not null constraint fk_O_No foreign key(O_No) references Outlet(Outlet_No),
Contact_No char(10) not null,
primary key(O_No)
);

create table Login_Data(
username varchar(12) not null,
passwd varchar(20) not null check (passwd like '%[0-9]%' and passwd like '%[A-Z]%' and passwd like '%[!@#$%^&*()-_=+.,]%' and len(passwd)>=6),
primary key (username,passwd)
);

create procedure delete_Ins(@Rec varchar(12))
as
begin
delete from Installment_Date where Rec_No=@Rec;
delete from Item_Bought_Ins where Rcipt_No=@Rec;
delete from Installment_Receipt where Receipt_No=@Rec;
end;

create procedure delete_Full(@Rec varchar(12))
as
begin
delete from Item_Bought_Full where Rcpt_No=@Rec;
delete from Full_Receipt where Receipt_No=@Rec;
end;