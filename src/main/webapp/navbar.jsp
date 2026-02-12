<%@ page contentType="text/html;charset=UTF-8" %>
<!-- 
	Lois Poh 
	2429478
 -->
<%
    String ctx = request.getContextPath();
%>

<nav class="navbar navbar-expand-lg" style="background-color:#bca8d9; padding: 15px 30px;">
  <style>
    .btn-soft { border-radius: 12px; padding: 8px 14px; font-weight: 700; }

    .btn-view {
      background: #ffffff;
      border: 1px solid #c4b5fd;
      color: #4b37b8;
    }
    .btn-view:hover { background: #f5f3ff; border-color: #a78bfa; }

    .btn-logout {
      background: #6d28d9;
      color: #fff;
      border: none;
    }
    .btn-logout:hover { filter: brightness(.95); }
  </style>

  <div class="container-fluid">
    <a class="navbar-brand fw-bold text-dark" href="<%= ctx %>/bookings.jsp">
      SilverCare Partner
    </a>

    <div class="ms-auto d-flex gap-2">
      <a id="navBookings" class="btn btn-soft btn-view d-none" href="<%= ctx %>/bookings.jsp">Partner Bookings</a>
      <button id="navLogout" class="btn btn-soft btn-logout d-none" type="button">Logout</button>
      <a id="navLogin" class="btn btn-soft btn-logout" href="<%= ctx %>/login.jsp">Login</a>
    </div>
  </div>
</nav>

<script>
  (function() {
    const token = sessionStorage.getItem("partner_token");

    const navBookings = document.getElementById("navBookings");
    const navLogout   = document.getElementById("navLogout");
    const navLogin    = document.getElementById("navLogin");

    if (token) {
      navBookings.classList.remove("d-none");
      navLogout.classList.remove("d-none");
      navLogin.classList.add("d-none");
    } else {
      navBookings.classList.add("d-none");
      navLogout.classList.add("d-none");
      navLogin.classList.remove("d-none");
    }

    navLogout.addEventListener("click", async () => {
      try { await fetch("http://localhost:8081/portal/partner/logout", { method: "POST" }); } catch (e) {}

      sessionStorage.removeItem("partner_token");
      window.location.href = "<%= ctx %>/login.jsp";
    });
  })();
</script>
