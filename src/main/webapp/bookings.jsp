<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true"%>
<%@ include file="/navbar.jsp"%>
<!-- 
	Lois Poh 
	2429478
 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Partner Bookings</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f5f3ff;
	font-family: 'Poppins', sans-serif;
}

.page-wrap {
	max-width: 1100px;
	margin: 30px auto;
	padding: 0 16px;
}

.cardx {
	background: #ffffff;
	border-radius: 18px;
	border: 1px solid #ede9fe;
	box-shadow: 0 12px 28px rgba(0, 0, 0, .06);
	padding: 18px;
}

.row-card {
	background: #fff;
	border: 1px solid #ede9fe;
	border-radius: 18px;
	padding: 16px 18px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
}

.avatar {
	width: 54px;
	height: 54px;
	border-radius: 50%;
	background: #ede9fe;
	color: #4b37b8;
	display: grid;
	place-items: center;
	font-weight: 800;
	font-size: 20px;
	flex: 0 0 auto;
}

.meta {
	display: flex;
	flex-wrap: wrap;
	gap: 14px;
	color: #4b5563;
	font-size: 14px;
}

.badge-id {
	background: #ede9fe;
	color: #4b37b8;
	border-radius: 999px;
	padding: 4px 10px;
	font-weight: 700;
	font-size: 12px;
	display: inline-block;
}

.btn-soft {
	border-radius: 12px;
	padding: 8px 14px;
	font-weight: 700;
}

.btn-view {
	background: #ffffff;
	border: 1px solid #c4b5fd;
	color: #4b37b8;
}

.btn-view:hover {
	background: #f5f3ff;
	border-color: #a78bfa;
}

.title {
	font-weight: 900;
	color: #3b2ea9;
	margin: 0;
}

.subtitle {
	color: #6b7280;
	margin: 0;
}
</style>
</head>

<body>
	<div class="page-wrap">
		<div class="d-flex align-items-center justify-content-between mb-3">
			<div>
				<h3 class="title">Partner Bookings</h3>
				<p class="subtitle">View bookings assigned to your company and
					open customer details.</p>
			</div>
		</div>

		<div class="cardx">
			<div id="empty" class="alert alert-warning mb-0 d-none">No
				bookings found for your partner account yet.</div>
			<div id="list" class="d-flex flex-column gap-3"></div>
		</div>
	</div>

	<script>
const CTX = "<%=ctx%>";
const SPRING_BASE = "http://localhost:8081/portal";

function firstLetter(serviceName) {
  if (!serviceName || serviceName.trim() === "") return "B";
  return serviceName.trim().charAt(0).toUpperCase();
}

function safeText(v) {
  if (v === null || v === undefined || v === "") return "—";
  return v;
}

function escapeHtml(s) {
  return String(s)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

async function loadBookings() {
  const token = sessionStorage.getItem("partner_token");
  if (!token) {
    window.location.href = CTX + "/login.jsp";
    return;
  }

  const res = await fetch(SPRING_BASE + "/partner/bookings/data", {
    headers: { "Authorization": "Bearer " + token }
  });

  if (res.status === 401) {
    sessionStorage.removeItem("partner_token");
    window.location.href = CTX + "/login.jsp";
    return;
  }

  if (!res.ok) {
    window.location.href = CTX + "/login.jsp";
    return;
  }

  const data = await res.json();
  const bookings = Array.isArray(data) ? data : [];

  const empty = document.getElementById("empty");
  const list = document.getElementById("list");

  if (bookings.length === 0) {
    empty.classList.remove("d-none");
    return;
  }

  bookings.forEach(b => {
    const bookingId = b.bookingId ?? b.booking_id;
    const detailId  = b.detailId  ?? b.detail_id;
    if (!detailId) return;
    const serviceName = b.serviceName ?? b.service_name;
    const start = b.startTime ?? b.start_time;
    const end   = b.endTime   ?? b.end_time;
    const subtotal = b.subtotal;
    const special  = b.specialRequest ?? b.special_request;

    const card = document.createElement("div");
    card.className = "row-card";

    card.innerHTML = `
      <div class="d-flex align-items-center gap-3">
        <div class="avatar">${firstLetter(serviceName)}</div>

        <div>
          <div class="fw-bold mb-1">
            Booking <span class="badge-id">ID: ${safeText(bookingId)}</span>
          </div>

          <div class="meta">
            <div><span class="fw-semibold">Service:</span> ${safeText(serviceName)}</div>
            <div><span class="fw-semibold">Start:</span> ${safeText(start)}</div>
            <div><span class="fw-semibold">End:</span> ${safeText(end)}</div>
            <div><span class="fw-semibold">Subtotal:</span> ${safeText(subtotal)}</div>
            ${special ? `<div><span class="fw-semibold">Request:</span> ${escapeHtml(special)}</div>` : ``}
          </div>
        </div>
      </div>

      <div>
        <a class="btn btn-soft btn-view" href="${CTX}/bookings_view.jsp?id=${encodeURIComponent(detailId)}">
          View
        </a>
      </div>
    `;

    list.appendChild(card);
  });
}

loadBookings().catch(() => window.location.href = CTX + "/login.jsp");
</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
