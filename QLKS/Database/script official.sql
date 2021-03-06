CREATE DATABASE QLKS
GO
USE [QLKS]
GO
/****** Object:  StoredProcedure [dbo].[Laydata]    Script Date: 20/6/2021 10:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Laydata]
 @ngaydau date , @ngaycuoi DATE
 AS 
 BEGIN 
	 DELETE dbo.data
	 DECLARE @ngay DATE 
	 SET @ngay = @ngaydau
	 DECLARE @sophong FLOAT
	 SELECT @sophong=COUNT(*) FROM dbo.phong
	 
	--------------------
	DECLARE @sophongsd FLOAT
	
	--------------------
	DECLARE @AOR FLOAT 

	--------------------
	DECLARE @doanhthuphongngay FLOAT

	--------------------
	DECLARE @ADR FLOAT

	--------------------
	DECLARE @tongdttheongay FLOAT

	--------------------------------------------
	DECLARE @trevPAR FLOAT

	-----------------------------------------------

	 WHILE (@ngay<=@ngaycuoi)
	 BEGIN
	 ------------------------------------------------------------------------
	SELECT @sophongsd=COUNT(*) FROM dbo.hoadonphong 
	WHERE ((@ngay<= ngaycheckout AND @ngay>= ngaycheckin )
	OR (ngaycheckout IS NULL AND @ngay>= ngaycheckin ))
	----------------
	SET @AOR = ROUND(@sophongsd /@sophong *100 ,3,0)
	----------------------------------------------------------------
	SELECT @doanhthuphongngay=SUM(giaphong) FROM dbo.phong,dbo.hoadonphong
	 WHERE hoadonphong.idphong=phong.idphong
	 AND ( ((@ngay<= ngaycheckout AND @ngay>= ngaycheckin )
		 OR (ngaycheckout IS NULL AND @ngay>= ngaycheckin )) )
	-------------------------------------------------------------------
	SET @ADR = ROUND(@doanhthuphongngay / @sophongsd ,3,0)
	--------------------------------------------------------
	
	SELECT @tongdttheongay = @doanhthuphongngay + SUM(giadv*soluong) FROM dbo.hoadondv,dbo.dichvu,dbo.hoadonphong
	 WHERE 
		hoadondv.idhdp= hoadonphong.idhdp
		AND dichvu.tendv = dbo.hoadondv.tendv
	 AND @ngay=ngaygoi
	 AND ( ((@ngay<= ngaycheckout AND @ngay>= ngaycheckin )
		 OR (ngaycheckout IS NULL AND @ngay>= ngaycheckin )) )
	IF (@tongdttheongay IS NULL) SET @tongdttheongay=@doanhthuphongngay
	--------------------------------------------
	SET @trevPAR=ROUND(@tongdttheongay/@sophong ,3,0)
	-----------------------------------------------
	 INSERT dbo.data VALUES 
	 (@ngay,@sophongsd,@AOR,@doanhthuphongngay,@ADR,@tongdttheongay,@trevPAR)
	 SET @ngay = DATEADD(DAY,1,@ngay) 
	 END	
END	



GO
/****** Object:  Table [dbo].[dangnhap]    Script Date: 20/6/2021 10:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dangnhap](
	[tdn] [varchar](10) NOT NULL,
	[mk] [varchar](200) NULL,
	[tennv] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[tdn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[data]    Script Date: 20/6/2021 10:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[data](
	[ngay] [date] NULL,
	[sophongsd] [int] NULL,
	[AOR] [float] NULL,
	[tongDTthuephongngay] [float] NULL,
	[ADR] [float] NULL,
	[tongDTngay] [float] NULL,
	[trevPAR] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dichvu]    Script Date: 20/6/2021 10:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dichvu](
	[tendv] [nvarchar](100) NOT NULL,
	[donvi] [nvarchar](20) NULL,
	[giadv] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[tendv] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[hoadondv]    Script Date: 20/6/2021 10:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hoadondv](
	[idhddv] [int] IDENTITY(1,1) NOT NULL,
	[idhdp] [int] NULL,
	[tendv] [nvarchar](100) NULL,
	[ngaygoi] [date] NULL,
	[soluong] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idhddv] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[hoadonphong]    Script Date: 20/6/2021 10:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hoadonphong](
	[idhdp] [int] IDENTITY(1,1) NOT NULL,
	[idkh] [int] NULL,
	[phuongthuctt] [nvarchar](50) NULL,
	[idphong] [varchar](20) NULL,
	[ngaycheckin] [date] NULL,
	[ngaycheckout] [date] NULL,
	[tongtien] [float] NULL,
	[tienphong] [float] NULL,
	[tiendichvu] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[idhdp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[khachhang]    Script Date: 20/6/2021 10:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[khachhang](
	[idkh] [int] IDENTITY(1,1) NOT NULL,
	[cmnd] [varchar](50) NULL,
	[hoten] [nvarchar](100) NULL,
	[diachi] [nvarchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[idkh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[phong]    Script Date: 20/6/2021 10:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[phong](
	[idphong] [varchar](20) NOT NULL,
	[loaiphong] [nvarchar](50) NULL,
	[sogiuong] [int] NULL,
	[trangthai] [nvarchar](100) NULL,
	[giaphong] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[idphong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[thongtin]    Script Date: 20/6/2021 10:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[thongtin](
	[tenks] [nvarchar](50) NULL,
	[tenchuks] [nvarchar](30) NULL,
	[diachi] [nvarchar](50) NULL,
	[sdt] [varchar](20) NULL,
	[masothue] [varchar](20) NULL,
	[ngaythanhlap] [datetime] NULL,
	[logofile] [nvarchar](150) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[dangnhap] ([tdn], [mk], [tennv]) VALUES (N'nv1', N'1', N'Nguyễn Quốc Anh')
INSERT [dbo].[dangnhap] ([tdn], [mk], [tennv]) VALUES (N'nv2', N'1', N'Chu Mai Phương')
INSERT [dbo].[dangnhap] ([tdn], [mk], [tennv]) VALUES (N'nv3', N'1', N'Nguyễn Thúy Quỳnh')
INSERT [dbo].[dangnhap] ([tdn], [mk], [tennv]) VALUES (N'nv4', N'1', N'Phạm Văn Diện')
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Bia', N'Lon', 15000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Bữa sáng', N'Bữa', 50000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Bữa tối', N'Bữa', 200000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Bữa trưa', N'Bữa', 150000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Coca', N'Lon', 1000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Dọn phòng', N'Lần', 150000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Karaoke', N'Lần', 100000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Làm nail', N'Lần', 200000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Mát-xa', N'Lần', 150000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Nước lọc', N'Chai', 8000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Xông hơi', N'Lần', 150000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Giặt là', N'Lần', 60000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Khăn lạnh', N'Cái', 5000)
INSERT [dbo].[dichvu] ([tendv], [donvi], [giadv]) VALUES (N'Bò húc', N'Lon', 15000)
SET IDENTITY_INSERT [dbo].[hoadondv] ON 

INSERT [dbo].[hoadondv] ([idhddv], [idhdp], [tendv], [ngaygoi], [soluong]) VALUES (1, 2, N'Karaoke', CAST(0x9D420B00 AS Date), 4)
INSERT [dbo].[hoadondv] ([idhddv], [idhdp], [tendv], [ngaygoi], [soluong]) VALUES (2, 3, N'Karaoke', CAST(0x9D420B00 AS Date), 3)
INSERT [dbo].[hoadondv] ([idhddv], [idhdp], [tendv], [ngaygoi], [soluong]) VALUES (3, 5, N'Dọn phòng', CAST(0x9F420B00 AS Date), 2)
INSERT [dbo].[hoadondv] ([idhddv], [idhdp], [tendv], [ngaygoi], [soluong]) VALUES (4, 6, N'Karaoke', CAST(0x9F420B00 AS Date), 1)
INSERT [dbo].[hoadondv] ([idhddv], [idhdp], [tendv], [ngaygoi], [soluong]) VALUES (5, 7, N'Nước lọc', CAST(0x9F420B00 AS Date), 10)
INSERT [dbo].[hoadondv] ([idhddv], [idhdp], [tendv], [ngaygoi], [soluong]) VALUES (6, 8, N'Coca', CAST(0xA0420B00 AS Date), 8)
SET IDENTITY_INSERT [dbo].[hoadondv] OFF
SET IDENTITY_INSERT [dbo].[hoadonphong] ON 
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (1, 1, NULL, N'P201', CAST(0x9D420B00 AS Date), CAST(0x9D420B00 AS Date), 200000, 200000, 0)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (2, 2, NULL, N'P202', CAST(0x9D420B00 AS Date), CAST(0x9D420B00 AS Date), 550000, 150000, 400000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (3, 1, NULL, N'P202', CAST(0x9D420B00 AS Date), CAST(0x9D420B00 AS Date), 450000, 150000, 300000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (4, 3, NULL, N'P201', CAST(0x9F420B00 AS Date), CAST(0xA0420B00 AS Date), 200000, 200000, 0)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (5, 4, NULL, N'P202', CAST(0x9F420B00 AS Date), CAST(0xA0420B00 AS Date), 450000, 150000, 300000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (6, 5, NULL, N'P203', CAST(0x9F420B00 AS Date), CAST(0x9F420B00 AS Date), 250000, 150000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (7, 6, NULL, N'P204', CAST(0x9F420B00 AS Date), CAST(0x9F420B00 AS Date), 180000, 100000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (8, 11, NULL, N'P201', CAST(0x9E420B00 AS Date), CAST(0xA0420B00 AS Date), 480000, 400000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (9, 1, NULL, N'P301', CAST(0x95420B00 AS Date), CAST(0x96420B00 AS Date), 280000, 200000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (10, 2, NULL, N'P302', CAST(0x95420B00 AS Date), CAST(0x96420B00 AS Date), 400000, 300000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (11, 3, NULL, N'P303', CAST(0x95420B00 AS Date), CAST(0x96420B00 AS Date), 250000, 150000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (12, 4, NULL, N'P304', CAST(0x95420B00 AS Date), CAST(0x97420B00 AS Date), 120000, 100000, 20000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (13, 5, NULL, N'P401', CAST(0x95420B00 AS Date), CAST(0x97420B00 AS Date), 350000, 200000, 150000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (14, 6, NULL, N'P402', CAST(0x96420B00 AS Date), CAST(0x97420B00 AS Date), 300000, 200000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (15, 7, NULL, N'P403', CAST(0x96420B00 AS Date), CAST(0x97420B00 AS Date), 330000, 300000, 30000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (16, 8, NULL, N'P404', CAST(0x96420B00 AS Date), CAST(0x97420B00 AS Date), 280000, 200000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (17, 9, NULL, N'P501', CAST(0x97420B00 AS Date), CAST(0x98420B00 AS Date), 210000, 150000, 60000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (18, 10, NULL, N'P502', CAST(0x97420B00 AS Date), CAST(0x98420B00 AS Date), 450000, 300000, 150000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (19, 11, NULL, N'P503', CAST(0x97420B00 AS Date), CAST(0x98420B00 AS Date), 300000, 200000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (20, 12, NULL, N'P504', CAST(0x97420B00 AS Date), CAST(0x99420B00 AS Date), 400000, 300000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (21, 13, NULL, N'P201', CAST(0x97420B00 AS Date), CAST(0x99420B00 AS Date), 500000, 400000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (22, 14, NULL, N'P202', CAST(0x97420B00 AS Date), CAST(0x99420B00 AS Date), 280000, 200000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (23, 15, NULL, N'P203', CAST(0x97420B00 AS Date), CAST(0x9A420B00 AS Date), 230000, 150000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (24, 16, NULL, N'P204', CAST(0x98420B00 AS Date), CAST(0x9A420B00 AS Date), 18000, 100000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (25, 17, NULL, N'P301', CAST(0x98420B00 AS Date), CAST(0x9A420B00 AS Date), 230000, 150000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (26, 18, NULL, N'P302', CAST(0x99420B00 AS Date), CAST(0x9B420B00 AS Date), 250000, 150000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (27, 19, NULL, N'P303', CAST(0x99420B00 AS Date), CAST(0x9B420B00 AS Date), 200000, 100000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (28, 20, NULL, N'P304', CAST(0x99420B00 AS Date), CAST(0x9B420B00 AS Date), 30000, 200000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (29, 21, NULL, N'P401', CAST(0x99420B00 AS Date), CAST(0x9B420B00 AS Date), 400000, 300000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (30, 22, NULL, N'P402', CAST(0x99420B00 AS Date), CAST(0x9B420B00 AS Date), 450000, 300000, 150000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (31, 23, NULL, N'P403', CAST(0x9A420B00 AS Date), CAST(0x9B420B00 AS Date), 470000, 350000, 120000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (32, 24, NULL, N'P404', CAST(0x9A420B00 AS Date), CAST(0x9B420B00 AS Date), 500000, 400000, 120000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (33, 25, NULL, N'P501', CAST(0x9A420B00 AS Date), CAST(0x9D420B00 AS Date), 600000, 400000, 130000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (34, 26, NULL, N'P502', CAST(0x9A420B00 AS Date), CAST(0x9D420B00 AS Date), 700000, 200000, 150000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (35, 27, NULL, N'P503', CAST(0x9B420B00 AS Date), CAST(0x9D420B00 AS Date), 300000, 300000, 120000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (36, 28, NULL, N'P504', CAST(0x9B420B00 AS Date), CAST(0x9D420B00 AS Date), 120000, 150000, 300000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (37, 29, NULL, N'P201', CAST(0x9B420B00 AS Date), CAST(0x9D420B00 AS Date), 150000, 300000, 150000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (38, 30, NULL, N'P202', CAST(0x9C420B00 AS Date), CAST(0x9E420B00 AS Date), 160000, 300000, 160000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (39, 31, NULL, N'P203', CAST(0x9C420B00 AS Date), CAST(0x9E420B00 AS Date), 130000, 150000, 200000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (40, 32, NULL, N'P204', CAST(0x9D420B00 AS Date), CAST(0x9E420B00 AS Date), 150000, 150000, 300000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (41, 33, NULL, N'P301', CAST(0x9D420B00 AS Date), CAST(0x9E420B00 AS Date), 500000, 15000, 150000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (42, 34, NULL, N'P302', CAST(0x9D420B00 AS Date), CAST(0x9F420B00 AS Date), 400000, 150000, 160000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (43, 35, NULL, N'P303', CAST(0x9D420B00 AS Date), CAST(0x9F420B00 AS Date), 600000, 150000, 130000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (44, 36, NULL, N'P304', CAST(0x9E420B00 AS Date), CAST(0x9F420B00 AS Date), 1000000, 300000, 120000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (45, 37, NULL, N'P401', CAST(0x9E420B00 AS Date), CAST(0x9F420B00 AS Date), 500000, 30000, 160000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (46, 38, NULL, N'P402', CAST(0x9E420B00 AS Date), CAST(0x9F420B00 AS Date), 600000, 300000, 130000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (47, 39, NULL, N'P403', CAST(0x9E420B00 AS Date), CAST(0x9F420B00 AS Date), 700000, 300000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (48, 40, NULL, N'P404', CAST(0x9E420B00 AS Date), CAST(0x9F420B00 AS Date), 800000, 300000, 100000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (49, 41, NULL, N'P501', CAST(0x9E420B00 AS Date), CAST(0x9F420B00 AS Date), 900000, 200000, 120000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (50, 42, NULL, N'P502', CAST(0x9E420B00 AS Date), CAST(0x9F420B00 AS Date), 50000, 200000, 130000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (51, 43, NULL, N'P503', CAST(0x9F420B00 AS Date), CAST(0xA0420B00 AS Date), 600000, 200000, 150000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (52, 44, NULL, N'P504', CAST(0x9F420B00 AS Date), CAST(0xA0420B00 AS Date), 400000, 200000, 160000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (53, 45, NULL, N'P201', CAST(0x9F420B00 AS Date), CAST(0xA0420B00 AS Date), 600000, 300000, 140000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (54, 46, NULL, N'P202', CAST(0x9F420B00 AS Date), CAST(0xA0420B00 AS Date), 700000, 150000, 130000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (55, 47, NULL, N'P203', CAST(0x9F420B00 AS Date), CAST(0xA0420B00 AS Date), 800000, 150000, 50000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (56, 48, NULL, N'P204', CAST(0x9F420B00 AS Date), CAST(0xA0420B00 AS Date), 900000, 100000, 50000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (57, 49, NULL, N'P301', CAST(0x94420B00 AS Date), CAST(0x95420B00 AS Date), 400000, 140000, 50000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (58, 50, NULL, N'P401', CAST(0x94420B00 AS Date), CAST(0x95420B00 AS Date), 500000, 120000, 50000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (59, 1, NULL, N'P402', CAST(0x94420B00 AS Date), CAST(0x95420B00 AS Date), 600000, 130000, 8000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (60, 2, NULL, N'P403', CAST(0x94420B00 AS Date), CAST(0x95420B00 AS Date), 500000, 160000, 80000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (61, 3, NULL, N'P404', CAST(0x94420B00 AS Date), CAST(0x95420B00 AS Date), 400000, 200000, 60000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (62, 4, NULL, N'P501', CAST(0x94420B00 AS Date), CAST(0x95420B00 AS Date), 600000, 210000, 60000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (63, 5, NULL, N'P502', CAST(0x93420B00 AS Date), CAST(0x95420B00 AS Date), 500000, 230000, 60000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (64, 6, NULL, N'P503', CAST(0x93420B00 AS Date), CAST(0x95420B00 AS Date), 400000, 230000, 50000)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (65, 1, NULL, N'P502', CAST(0xA6420B00 AS Date), CAST(0xA6420B00 AS Date), 150000, 150000, 0)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (66, 1, NULL, N'P502', CAST(0xA6420B00 AS Date), CAST(0xA6420B00 AS Date), 150000, 150000, 0)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (67, 6, NULL, N'P502', CAST(0xA6420B00 AS Date), CAST(0xA6420B00 AS Date), 150000, 150000, 0)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (68, 1, NULL, N'P204', CAST(0xA6420B00 AS Date), CAST(0xA6420B00 AS Date), 100000, 100000, 0)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (69, 5, NULL, N'P502', CAST(0xA6420B00 AS Date), CAST(0xA6420B00 AS Date), 150000, 150000, 0)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (70, 7, NULL, N'P401', CAST(0xA6420B00 AS Date), CAST(0xA6420B00 AS Date), 200000, 200000, 0)
INSERT [dbo].[hoadonphong] ([idhdp], [idkh], [phuongthuctt], [idphong], [ngaycheckin], [ngaycheckout], [tongtien], [tienphong], [tiendichvu]) VALUES (71, 8, NULL, N'P502', CAST(0xA6420B00 AS Date), CAST(0xA6420B00 AS Date), 150000, 150000, 0)

SET IDENTITY_INSERT [dbo].[hoadonphong] OFF
SET IDENTITY_INSERT [dbo].[khachhang] ON 

INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (1, N'111', N'Nguyễn Quang Hải', N'Hà Nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (2, N'222', N'Nguyễn Tiến Linh', N'Hải Dương')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (3, N'001', N'Vũ Văn Thanh', N'Hải Dương')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (4, N'002', N'Bùi Tấn Trường', N'Hải Dương')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (5, N'003', N'Nguyễn Quốc Anh', N'Hà Nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (6, N'004', N'Phạm Văn Diện', N'Hải Dương')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (7, N'005', N'Đỗ Duy Mạnh', N'Thái Bình')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (8, N'006', N'Quế Ngọc Hải', N'Nghệ An')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (9, N'007', N'Đỗ Hùng Dũng', N'Hà Nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (10, N'008', N'Lương Xuân Trường', N'Gia Lai')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (11, N'009', N'Nguyễn Trọng Hoàng', N'Thanh Hóa')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (12, N'010', N'Phạm Đức Huy', N'Hà Nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (13, N'011', N'Nguyễn Huy Hùng', N'Quảng Nam')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (14, N'012', N'Lê Thu Hà', N'Hai Bà Trưng')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (15, N'013', N'Lê thị dinh', N'Hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (16, N'014', N'Lê thị lan phương', N'Thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (17, N'015', N'Đào thuỳ dung', N'Hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (18, N'016', N'Nguyễn thu hương', N'Hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (19, N'017', N'Nguyễn lan hương', N'Thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (20, N'018', N'Nguyễn văn định', N'Hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (21, N'019', N'Nguyễn thị hải', N'hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (22, N'020', N'Diệp minh hạnh', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (23, N'021', N'Đời thi hồng', N'Quảng ninh')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (24, N'022', N'Bùi thị lan', N'Hải phong')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (25, N'023', N'Nguyễn thị liên', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (26, N'024', N'Dương kim liên', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (27, N'025', N'Vũ thị liên', N'Hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (28, N'026', N'Lê ngọc long', N'Hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (29, N'027', N'Nguyễn hoàng linh', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (30, N'028', N'Pham đình năng', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (31, N'029', N'Phạm hồng nhung', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (32, N'030', N'Trần thị hằng nga', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (33, N'031', N'Nguyễn thị ninh', N'hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (34, N'032', N'Lê thu hương', N'hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (35, N'033', N'Phạm thị phương', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (36, N'034', N'Bùi ngọc thu', N'Hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (37, N'035', N'Đào thanh tâm', N'hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (38, N'036', N'Trần đình thân', N'hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (39, N'037', N'Hoàng anh tuấn', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (40, N'038', N'Phan thị thuỷ', N'hà nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (41, N'039', N'Ngô thị thanh thuý', N'thanh hoá')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (42, N'040', N'Lê thanh tùng', N'nam định')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (43, N'041', N'Nguyễn Văn Hùng', N'Thái Bình')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (44, N'042', N'Nguyễn Thanh Tùng', N'Hà Giang')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (45, N'043', N'James', N'Lũng Cú')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (46, N'044', N'Dan', N'Hà Nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (47, N'045', N'park', N'Hà Nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (48, N'046', N'Tilo', N'Hà Nội')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (49, N'047', N'Moon', N'Hải Dương')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (50, N'048', N'Martin', N'Hải Dương')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (51, N'049', N'Born', N'Hải Dương')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (52, N'050', N'Phạm Văn Tuấn', N'Hải Dương')
INSERT [dbo].[khachhang] ([idkh], [cmnd], [hoten], [diachi]) VALUES (53, N'051', N'Vũ Khánh', N'Huế')
SET IDENTITY_INSERT [dbo].[khachhang] OFF
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P201', N'Vip', 2, N'Trống', 200000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P202', N'Thường', 2, N'Trống', 150000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P203', N'Vip', 1, N'Trống', 150000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P204', N'Thường', 1, N'Trống', 100000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P301', N'Vip', 1, N'Trống', 150000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P302', N'Vip', 2, N'Trống', 200000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P303', N'Thường', 2, N'Trống', 150000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P304', N'Thường', 1, N'Trống', 100000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P401', N'Vip', 2, N'Trống', 200000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P402', N'Vip', 1, N'Trống', 150000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P403', N'Thường', 2, N'Trống', 150000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P404', N'Thường', 1, N'Trống', 100000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P501', N'Vip', 2, N'Trống', 200000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P502', N'Vip', 1, N'Trống', 150000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P503', N'Thường', 2, N'Trống', 150000)
INSERT [dbo].[phong] ([idphong], [loaiphong], [sogiuong], [trangthai], [giaphong]) VALUES (N'P504', N'Thường', 1, N'Trống', 100000)
INSERT [dbo].[thongtin] ([tenks], [tenchuks], [diachi], [sdt], [masothue], [ngaythanhlap], [logofile]) VALUES (N'', N'', N'', N'', N'', CAST(0x0000AD2000000000 AS DateTime), N'')
