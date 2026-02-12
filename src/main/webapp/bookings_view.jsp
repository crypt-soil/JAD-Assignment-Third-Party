<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true"%>
<%@ include file="/navbar.jsp"%>
<!-- 
	Lois Poh 
	2429478
 -->
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Booking Details</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
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
	background: #fff;
	border-radius: 18px;
	border: 1px solid #ede9fe;
	box-shadow: 0 12px 28px rgba(0, 0, 0, .06);
	padding: 18px;
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

.btn-soft {
	border-radius: 12px;
	padding: 8px 14px;
	font-weight: 700;
}

.btn-view {
	background: #fff;
	border: 1px solid #c4b5fd;
	color: #4b37b8;
}

.btn-view:hover {
	background: #f5f3ff;
	border-color: #a78bfa;
}

.section-card {
	background: #fff;
	border: 1px solid #ede9fe;
	border-radius: 18px;
	overflow: hidden;
}

.section-head {
	background: #faf7ff;
	border-bottom: 1px solid #ede9fe;
	padding: 12px 16px;
	font-weight: 800;
	color: #111827;
}

.section-body {
	padding: 14px 16px;
}

.kv {
	display: grid;
	grid-template-columns: 180px 1fr;
	gap: 8px 14px;
	font-size: 14px;
	color: #374151;
}

.kv b {
	color: #111827;
}

.muted {
	color: #6b7280;
}

.pill {
	background: #ede9fe;
	color: #4b37b8;
	border-radius: 999px;
	padding: 4px 10px;
	font-weight: 800;
	font-size: 12px;
	display: inline-block;
}
</style>
</head>

<body>
	<div class="page-wrap">
		<div class="d-flex align-items-center justify-content-between mb-3">
			<div>
				<h3 class="title">Booking Details</h3>
				<p class="subtitle">View job info and the customer's personal /
					medical details.</p>
			</div>

			<a class="btn btn-soft btn-view" href="<%=ctx%>/bookings.jsp">Back</a>
		</div>

		<div id="err" class="alert alert-danger d-none"></div>

		<div class="cardx d-flex flex-column gap-3">
			<div class="section-card">
				<div class="section-head">Job Info</div>
				<div class="section-body" id="job">
					<div class="muted">Loading…</div>
				</div>
			</div>

			<div class="section-card">
				<div class="section-head">Customer Personal Info</div>
				<div class="section-body" id="customer">
					<div class="muted">Loading…</div>
				</div>
			</div>

			<div class="section-card">
				<div class="section-head">Medical Info</div>
				<div class="section-body" id="medical">
					<div class="muted">Loading…</div>
				</div>
			</div>

			<div class="section-card">
				<div class="section-head">Emergency Contacts</div>
				<div class="section-body" id="contacts">
					<div class="muted">Loading…</div>
				</div>
			</div>
		</div>
	</div>

	<script>
const CTX = "<%=ctx%>";
const SPRING_BASE = "http://localhost:8081/portal";

function showErr(msg){
  const el = document.getElementById("err");
  el.textContent = msg;
  el.classList.remove("d-none");
}

function safe(v){
  return (v === null || v === undefined || v === "") ? "—" : v;
}

function escapeHtml(s) {
  return String(s)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

// supports camelCase or snake_case
function pick(obj, camel, snake){
  if (!obj) return undefined;
  return obj[camel] ?? obj[snake];
}

async function load() {
  const token = sessionStorage.getItem("partner_token");
  if (!token) {
    window.location.href = CTX + "/login.jsp";
    return;
  }

  const params = new URLSearchParams(window.location.search);
  const detailId = params.get("id");
  if (!detailId) {
    showErr("Missing booking detail id.");
    return;
  }

  const res = await fetch(
    SPRING_BASE + "/partner/bookings/" + encodeURIComponent(detailId) + "/data",
    { headers: { "Authorization": "Bearer " + token } }
  );

  if (res.status === 401) {
    sessionStorage.removeItem("partner_token");
    window.location.href = CTX + "/login.jsp";
    return;
  }

  if (!res.ok) {
    showErr("Failed to load booking detail.");
    return;
  }

  const data = await res.json();
  const d = data.detail || data;

  // job
  const detailIdVal  = pick(d, "detailId", "detail_id");
  const bookingIdVal = pick(d, "bookingId", "booking_id");
  const serviceName  = pick(d, "serviceName", "service_name");
  const startTime    = pick(d, "startTime", "start_time");
  const endTime      = pick(d, "endTime", "end_time");
  const subtotal     = pick(d, "subtotal", "subtotal");
  const specialReq   = pick(d, "specialRequest", "special_request");

  document.getElementById("job").innerHTML = `
    <div class="d-flex gap-2 mb-3">
      <span class="pill">Detail ID: ${escapeHtml(safe(detailIdVal))}</span>
      <span class="pill">Booking ID: ${escapeHtml(safe(bookingIdVal))}</span>
    </div>

    <div class="kv">
      <b>Service</b><div>${escapeHtml(safe(serviceName))}</div>
      <b>Start</b><div>${escapeHtml(safe(startTime))}</div>
      <b>End</b><div>${escapeHtml(safe(endTime))}</div>
      <b>Subtotal</b><div>${escapeHtml(safe(subtotal))}</div>
      <b>Special Request</b><div>${escapeHtml(safe(specialReq))}</div>
    </div>
  `;

  // customer (may be flattened or nested)
  const customerName    = pick(d, "customerName", "customer_name") ?? pick(data, "customerName", "customer_name");
  const customerPhone   = pick(d, "customerPhone", "customer_phone") ?? pick(data, "customerPhone", "customer_phone");
  const customerEmail   = pick(d, "customerEmail", "customer_email") ?? pick(data, "customerEmail", "customer_email");
  const customerAddress = pick(d, "customerAddress", "customer_address") ?? pick(data, "customerAddress", "customer_address");
  const customerZipcode = pick(d, "customerZipcode", "customer_zipcode") ?? pick(data, "customerZipcode", "customer_zipcode");

  document.getElementById("customer").innerHTML = `
    <div class="kv">
      <b>Name</b><div>${escapeHtml(safe(customerName))}</div>
      <b>Phone</b><div>${escapeHtml(safe(customerPhone))}</div>
      <b>Email</b><div>${escapeHtml(safe(customerEmail))}</div>
      <b>Address</b><div>${escapeHtml(safe(customerAddress))}</div>
      <b>Zipcode</b><div>${escapeHtml(safe(customerZipcode))}</div>
    </div>
  `;

  // medical
  const m = data.medical || {};
  const conditions = pick(m, "conditionsCsv", "conditions_csv");
  const allergies  = pick(m, "allergiesText", "allergies_text");

  document.getElementById("medical").innerHTML = `
    <div class="kv">
      <b>Conditions</b><div>${escapeHtml(safe(conditions))}</div>
      <b>Allergies</b><div>${escapeHtml(safe(allergies))}</div>
    </div>
  `;

  // contacts
  const contacts = Array.isArray(data.contacts) ? data.contacts : [];
  document.getElementById("contacts").innerHTML = contacts.length ? `
    <div class="d-flex flex-column gap-2">
      ${contacts.map(c => `
        <div class="kv">
          <b>Name</b><div>${escapeHtml(safe(pick(c,"contactName","contact_name")))}</div>
          <b>Relationship</b><div>${escapeHtml(safe(pick(c,"relationship","relationship")))}</div>
          <b>Phone</b><div>${escapeHtml(safe(pick(c,"phone","phone")))}</div>
          <b>Email</b><div>${escapeHtml(safe(pick(c,"email","email")))}</div>
        </div>
        <hr class="my-1" />
      `).join("")}
    </div>
  ` : `<div class="muted">—</div>`;
}

load().catch((e) => {
  console.error(e);
  showErr("Unexpected error loading page.");
});
</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
