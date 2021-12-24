<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="LapPhieuMuaHang.aspx.cs" Inherits="MILONA_WEB.WebForm17" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function NhapSanPham() {
            var danhmuc = document.getElementById("ContentPlaceHolder1_dropdownNCC")
            var options = danhmuc.childNodes;
            // Biến lưu trữ các chuyên mục đa chọn
            var giatridm = '';
            // lặp qua từng option và kiểm tra thuộc tính selected
            for (var i = 0; i < options.length; i++) {
                if (options[i].selected) {
                    giatridm = options[i].value;
                }
            }
            var xhttp = new XMLHttpRequest();
            var table = document.getElementById("table");
            var numberrow = table.children[1].children.length;
            var json = "{ numberrow :\"" + numberrow + "\",";
            json += "MaNCC :\"" + giatridm + "\",";
            for (var i = 0; i < numberrow; i++) {

                var Soluong = table.children[1].children[i].children[4].children[0].value;
                var MaSP = table.children[1].children[i].children[5].children[0].value;
                json += i + ": { MaSP : \"" + MaSP + "\", Soluong :\"" + Soluong + "\"}, ";
            }
            json += "}";
            xhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    var json = JSON.parse(xhttp.responseText);
                    var object = JSON.parse(json.d);
                    alert(object.thongbao);
                }
            };
            var abc = { Message: json };
            xhttp.open("POST", "/LapPhieuMuaHang.aspx/btnluu_Click", true);
            xhttp.setRequestHeader("Content-type", "application/json; charset=utf-8");
            xhttp.send(JSON.stringify(abc));
        }
        function XoaSanPham(obj) {

            var masp = obj.value;
            var datax = "{masp: \"" + masp + "\" }";
            $.ajax({
                type: "POST",
                url: '/LapPhieuMuaHang.aspx/btnxoa_Click',
                data: datax,
                contentType: "application/json; charset=utf-8",
                crossDomain: true,
                async: false,
                success: function (data) {
                    obj.parentElement.parentElement.remove();
                },
                failure: function (response) {
                    alert(response.d);
                }
            });
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <form name="myform" id="myform" action="/LapPhieuMuaHang.aspx" method="post" runat="server">
            <!-- Page Heading -->
            <h3 class="h3 mb-2 text-gray-800">Danh sách sản phẩm</h3>
            <!-- DataTales Example -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Sản Phẩm</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <div id="dataTable_wrapper" class="dataTables_wrapper dt-bootstrap4">
                            <div class="row">
                                <div class="col-sm-12 col-md-12">
                                    <div class="input-group col-md-4 col-sm-12">
                                        <input type="text" name="inputtimkiem" id="inputtimkiem" class="form-control bg-light border-0 small txt_search" placeholder="Search for...">
                                        <div class="input-group-append">
                                            <button class="btn form-control btn-primary btn_search" type="submit">
                                                <i class="bi bi-search"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <table class="table table-bordered dataTable" id="dataTable" width="100%" cellspacing="0" role="grid" style="width: 100%;">
                                    <thead>
                                        <tr role="row">
                                            <th class="sorting_asc" tabindex="0" rowspan="1" colspan="1" style="width: 160px;">Tên sản phẩm</th>
                                            <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 210px;">Danh mục</th>
                                            <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 114px;">Ảnh</th>
                                            <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 100px;">Giá bán</th>
                                            <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 100px;">Gía mua</th>
                                            <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 50px;">Số lượng</th>
                                            <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 110px;">Thêm vào DS</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:ListView ID="ListViewSanpham" runat="server">
                                            <ItemTemplate>
                                                <tr role="row">
                                                    <td><%# Eval("TenSP") %></td>
                                                    <td><%# Eval("TenDM") %></td>
                                                    <td>
                                                        <div class="product-img">
                                                            <img src="<%# Eval("Image1") %>" alt="<%# Eval("Image1") %>" />
                                                        </div>
                                                    </td>
                                                    <td class="card-detail-badge"><%# Eval("GiaBan") %></td>
                                                    <td class="card-detail-badge"><%# Eval("Giamua") %></td>
                                                    <td><%# Eval("Soluong") %></td>
                                                    <td>
                                                        <asp:Button Text="Thêm" ID="btnthem" CssClass="btn btn-primary" CommandArgument='<%# Eval("MaSP") %>' OnClick="btnthem_Click" runat="server" />
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:ListView>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Danh sách nhập</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <table class="table table-bordered dataTable" id="table" width="100%" cellspacing="0" role="grid" style="width: 100%;">
                                <thead>
                                    <tr role="row">
                                        <th class="sorting_asc" tabindex="0" rowspan="1" colspan="1" style="width: 210px;">Tên sản phẩm</th>
                                        <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 154px;">Ảnh</th>
                                        <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 90px;">Gía bán</th>
                                        <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 90px;">Gía mua</th>
                                        <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 90px;">Số lượng</th>
                                        <th class="sorting" tabindex="0" rowspan="1" colspan="1" style="width: 118px;">Xóa khỏi DS</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:ListView ID="LsSanPhamNhap" runat="server">
                                        <ItemTemplate>
                                            <tr role="row">
                                                <td><%# Eval("TenSP") %></td>
                                                <td>
                                                    <div class="product-img">
                                                        <img src="<%# Eval("Image") %>" alt="<%# Eval("Image") %>" />
                                                    </div>
                                                </td>
                                                <td class="card-detail-badge"><%# Eval("GiaBan") %></td>
                                                <td class="card-detail-badge"><%# Eval("Giamua") %></td>
                                                <td>
                                                    <input type="number" id="txtsoluong" min="1" max="100" value="1" class="form-control" />
                                                </td>
                                                <td>
                                                    <button type="button" id="btnxoa" class="btnxoa btn btn-primary" value="<%# Eval("MaSP") %>" onclick="XoaSanPham(this)">Xóa</button>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:ListView>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-md-4">
                            <div class="h-100 justify-content-center align-items-center" id="dataTable_length">
                                Nhà cung cấp:
                                <label>
                                     <asp:DropDownList ID="dropdownNCC" runat="server" CssClass="select_danhmuc form-control"></asp:DropDownList>
                                </label>
                            </div>
                        </div>
                    </div>
                    <button type="button" id="btnluu" class="btnluu btn btn-primary" onclick="NhapSanPham()">Lưu lại</button>
                </div>
            </div>
        </form>
    </div>

</asp:Content>
