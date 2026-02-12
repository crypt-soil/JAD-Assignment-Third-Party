<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/navbar.jsp"%>
<!-- 
	Lois Poh 
	2429478
 -->
<%
String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>SilverCare - Companion Partner Login</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap"
	rel="stylesheet">

<style>
body {
	font-family: 'Poppins', sans-serif;
	background-color: #f9f9f9;
	margin: 0;
}

.full-height {
	min-height: 100vh;
}

.login-image {
	background-size: cover;
	background-position: center;
	min-height: 100vh;
	background-image:
		url('https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?auto=format&fit=crop&w=1200&q=80');
}

.form-side {
	display: flex;
	flex-direction: column;
	justify-content: center;
	padding: 80px 100px;
	background-color: #fff;
}

.subtitle {
	font-size: 0.9rem;
	color: #666;
	margin-top: 6px;
	margin-bottom: 18px;
}

.btn-login {
	background-color: #7b50c7;
	color: white;
	border: none;
	border-radius: 25px;
	padding: 10px;
	width: 100%;
	font-weight: 600;
	box-shadow: 0 3px 10px rgba(120, 90, 255, 0.3);
}

.btn-login:hover {
	background-color: #693fb3;
}
</style>
</head>

<body>
	<div class="container-fluid g-0 full-height">
		<div class="row g-0 full-height">
			<div class="col-md-6 login-image"></div>

			<div class="col-md-6 form-side">
				<h2 class="mb-0">Welcome back!</h2>
				<p class="subtitle">Companion Partner Portal</p>

				<div id="errorBox"
					class="alert alert-danger text-center <%=(error == null ? "d-none" : "")%>">
					<%=(error == null ? "" : error)%>
				</div>

				<form id="loginForm">
					<div class="mb-3">
						<label class="form-label">Email</label> <input id="email"
							type="email" class="form-control" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Password</label> <input id="password"
							type="password" class="form-control" required>
					</div>

					<button type="submit" class="btn btn-login">LOG IN</button>
				</form>
			</div>
		</div>
	</div>

	<script>
  const SPRING_BASE = "http://localhost:8081/portal";
  const CTX = "<%=ctx%>";
  const errorBox = document.getElementById("errorBox");

  // if already logged in, go bookings
  if (sessionStorage.getItem("partner_token")) {
    window.location.href = CTX + "/bookings.jsp";
  }

  document.getElementById("loginForm").addEventListener("submit", async (e) => {
    e.preventDefault();
    errorBox.classList.add("d-none");
    errorBox.textContent = "";

    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;

    try {
      const res = await fetch(SPRING_BASE + "/partner/login", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({ email, password })
      });

      if (!res.ok) {
        errorBox.textContent = "Invalid login.";
        errorBox.classList.remove("d-none");
        return;
      }

      const data = await res.json();
      if (!data || !data.token) {
        errorBox.textContent = "Login failed.";
        errorBox.classList.remove("d-none");
        return;
      }

      sessionStorage.setItem("partner_token", data.token);
      window.location.href = CTX + "/bookings.jsp";

    } catch (err) {
      errorBox.textContent = "Login error. Is companion-portal running?";
      errorBox.classList.remove("d-none");
    }
  });
</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
