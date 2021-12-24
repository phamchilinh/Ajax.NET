using MILONA_WEB.DAO;
using MILONA_WEB.DTO;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MILONA_WEB
{
    public partial class WebForm17 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["login"].ToString() == "1")
            {
                if (Request.Form["inputtimkiem"] != null && Request.Form["inputtimkiem"] != "")
                {
                    DataTable table_sanpham = SanphamDAO.Instance1.Get_SanphamByName(Request.Form["inputtimkiem"].ToString());
                    ListViewSanpham.DataSource = table_sanpham;
                    ListViewSanpham.DataBind();
                }
                dropdownNCC.DataSource = NhaCungCapDAO.Instance1.Get_NhaCungCap();
                dropdownNCC.DataTextField = "TenNCC";
                dropdownNCC.DataValueField = "MaNCC";
                dropdownNCC.DataBind();
                List<SanphamDTO> sanphams = (List<SanphamDTO>)Session["lsSanPhieuNhap"];
                LsSanPhamNhap.DataSource = sanphams;
                LsSanPhamNhap.DataBind();

            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
        protected void btnthem_Click(object sender, EventArgs e)
        {
            int MaSP = Convert.ToInt32(((Button)sender).CommandArgument.ToString());
            List<SanphamDTO> sanphams = (List<SanphamDTO>)Session["lsSanPhieuNhap"];
            DataTable table_sanpham = SanphamDAO.Instance1.Get_SanphamByID(MaSP);
            SanphamDTO sanpham = new SanphamDTO(table_sanpham.Rows[0]);
            sanphams.Add(sanpham);
            Session["lsSanPhieuNhap"] = sanphams;
            Response.Redirect("LapPhieuMuaHang.aspx");
        }
        [WebMethod(EnableSession = true)]
        public static string btnluu_Click(string Message)
        {
            DataTable table_listsp = new DataTable();
            table_listsp.Columns.Add("MaSP", typeof(Int32));
            table_listsp.Columns.Add("Soluong", typeof(Int32));
            var result = JsonConvert.DeserializeObject<dynamic>(Message);
            int numberrow = (int)result["numberrow"];
            int MaTK = Convert.ToInt32(HttpContext.Current.Session["MaTK"]);
            int MaNCC = result["MaNCC"];
            if (numberrow != 0)
            {
                for (int i = 0; i < numberrow; i++)
                {
                    table_listsp.Rows.Add(Convert.ToInt32(result[i + ""]["MaSP"]), Convert.ToInt32(result[i + ""]["Soluong"]));
                }
                bool ketqua = PhieuMuaDAO.Instance1.LapPhieuMuaHang(MaNCC, MaTK, table_listsp);
                if (ketqua)
                {
                    HttpContext.Current.Session["lsSanPhieuNhap"] = new List<SanphamDTO>();
                    return "{\"thongbao\" : \"đã thêm thành công!\"}";

                }
                else
                    return "{ \"thongbao\" : \"đã thêm thất bại!\"}";
            }
            else
                return "{ \"thongbao\" : \"Nhập sản phẩm để Lập phiếu mua!\"}";

        }
        [WebMethod(EnableSession = true)]
        public static string btnxoa_Click(string masp)
        {
            List<SanphamDTO> sanphams = (List<SanphamDTO>)HttpContext.Current.Session["lsSanPhieuNhap"];
            List<SanphamDTO> sanphams2 = sanphams.ToList();
            foreach (var sp in sanphams)
            {
                if (sp.MaSP == Convert.ToInt32(masp))
                {
                    sanphams2.Remove(sp);
                }
            }
            HttpContext.Current.Session["lsSanPhieuNhap"] = sanphams2;
            return "{\"The message\" : \"ok\"}";
        }
    }
}