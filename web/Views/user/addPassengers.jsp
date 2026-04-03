<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    Integer seatsObj = (Integer) session.getAttribute("numSeats");
    int numSeats = (seatsObj == null) ? 1 : seatsObj;
    String bookingId = request.getParameter("bookingId");
    if (bookingId == null) { response.sendRedirect("userDashboard"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passenger Details – SkyConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .passenger-card {
            background: rgba(10,18,45,.7);
            border: 1px solid rgba(255,255,255,.1);
            border-radius: 16px;
            padding: 24px 28px;
            margin-bottom: 18px;
            backdrop-filter: blur(28px);
            position: relative;
            overflow: hidden;
            animation: fadeUp .5s ease both;
        }
        .passenger-card::before {
            content:'';
            position:absolute; top:0; left:0; right:0; height:2px;
            background: linear-gradient(90deg,transparent,var(--sky),var(--sky-glow),transparent);
        }
        .passenger-num {
            font-family:'Syne',sans-serif;
            font-size:1rem;
            font-weight:700;
            color:var(--sky-glow);
            margin-bottom:18px;
        }
        .seat-section { margin-top:20px; padding-top:16px; border-top:1px dashed rgba(255,255,255,.08); }
        .seat-grid { display:flex; flex-wrap:wrap; gap:8px; margin-top:10px; }
        .seat {
            width:50px; height:44px;
            border-radius:8px;
            border:1.5px solid rgba(0,87,255,.4);
            background:rgba(0,87,255,.07);
            color:rgba(77,138,255,.9);
            font-size:.75rem;
            font-weight:700;
            cursor:pointer;
            display:flex; align-items:center; justify-content:center;
            transition:all .18s;
            user-select:none;
        }
        .seat:hover { background:rgba(0,87,255,.2); transform:scale(1.05); }
        .seat.selected { background:var(--sky); color:var(--white); border-color:var(--sky-glow); }
        .seat.disabled { background:rgba(239,68,68,.08); color:rgba(239,68,68,.3); border-color:rgba(239,68,68,.15); cursor:not-allowed; transform:none; }
        .seat-hint { font-size:.72rem; color:var(--muted); margin-top:6px; }
    </style>
</head>
<body>

<div class="page-bg"></div>
<div class="stars-layer" id="stars"></div>

<nav class="navbar">
    <a href="userDashboard" class="nav-brand">
        <div class="brand-icon">✈</div>
        <span class="brand-name">Sky<span>Connect</span></span>
    </a>
    <div class="nav-links">
        <a href="userDashboard" class="nav-link">Dashboard</a>
        <a href="userBookings" class="nav-link">My Bookings</a>
        <a href="logout" class="nav-link btn-danger">Logout</a>
    </div>
</nav>

<div class="page-wrapper medium">

    <!-- STEPS -->
    <div class="steps">
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Search</div></div>
        <div class="step-line done"></div>
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Book</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">3</div><div class="step-label">Passengers</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">4</div><div class="step-label">Payment</div></div>
        <div class="step-line"></div>
        <div class="step"><div class="step-circle">5</div><div class="step-label">Ticket</div></div>
    </div>

    <div class="page-header">
        <div>
            <h1 class="page-title">👥 Passenger Details</h1>
            <p class="page-subtitle">Please fill in details for all <%= numSeats %> passenger(s)</p>
        </div>
    </div>

    <form action="savePassengers" method="post">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">

        <% for (int i = 1; i <= numSeats; i++) { %>
        <div class="passenger-card" style="animation-delay:<%= (i - 1) * 0.08 %>s">
            <div class="passenger-num">✈ Passenger <%= i %> of <%= numSeats %></div>

            <div class="form-grid">

                <div class="field full">
                    <label>Full Name</label>
                    <div class="field-wrap">
                        <span class="field-icon">👤</span>
                        <input type="text" name="full_name[]" placeholder="Enter full name" required>
                    </div>
                </div>

                <div class="field">
                    <label>Date of Birth</label>
                    <div class="field-wrap">
                        <span class="field-icon">🎂</span>
                        <input type="date" name="dob[]" class="dob-field" data-age-id="age<%= i %>" required>
                    </div>
                </div>

                <div class="field">
                    <label>Age (auto-filled)</label>
                    <div class="field-wrap">
                        <span class="field-icon">🔢</span>
                        <input type="number" name="age[]" id="age<%= i %>" placeholder="Auto" readonly required>
                    </div>
                </div>

                <div class="field">
                    <label>Gender</label>
                    <div class="field-wrap">
                        <span class="field-icon">⚧</span>
                        <select name="gender[]" required>
                            <option value="">Select</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>

                <div class="field">
                    <label>Phone</label>
                    <div class="field-wrap">
                        <span class="field-icon">📱</span>
                        <input type="text" name="phone[]" placeholder="Mobile number">
                    </div>
                </div>

                <div class="field full">
                    <label>Email</label>
                    <div class="field-wrap">
                        <span class="field-icon">✉</span>
                        <input type="email" name="email[]" placeholder="passenger@email.com">
                    </div>
                </div>

            </div>

            <!-- SEAT SELECTION -->
            <div class="seat-section">
                <div class="section-label">🪑 Select Seat <span style="font-weight:400;text-transform:none;letter-spacing:0">(optional)</span></div>
                <input type="hidden" name="seat_no[]" class="seat-input">
                <div class="seat-grid">
                    <% String[] seatList = {"A1","A2","A3","A4","A5","A6","B1","B2","B3","B4","B5","B6","C1","C2","C3","C4","C5","C6","D1","D2","D3","D4","D5","D6"};
                       for (String s : seatList) { %>
                        <div class="seat" data-seat="<%= s %>"><%= s %></div>
                    <% } %>
                </div>
                <div class="seat-hint">Click a seat to select · click again to deselect</div>
            </div>
        </div>
        <% } %>

        <div style="display:flex;justify-content:flex-end;margin-top:8px;">
            <button type="submit" class="btn btn-blue" style="padding:14px 32px;font-family:'Syne',sans-serif;font-weight:700;font-size:1rem;">
                Save & Continue to Payment →
            </button>
        </div>
    </form>

</div>

<script>
document.querySelectorAll('.dob-field').forEach(dob => {
    dob.addEventListener('change', function() {
        const d = new Date(this.value), t = new Date();
        let age = t.getFullYear() - d.getFullYear();
        if (t.getMonth() - d.getMonth() < 0 || (t.getMonth() === d.getMonth() && t.getDate() < d.getDate())) age--;
        const inp = document.getElementById(this.dataset.ageId);
        if (inp) inp.value = age >= 0 ? age : '';
    });
});

let selectedSeats = new Set();
document.querySelectorAll('.passenger-card').forEach(card => {
    const input = card.querySelector('.seat-input');
    card.querySelectorAll('.seat').forEach(seat => {
        seat.addEventListener('click', () => {
            if (seat.classList.contains('disabled')) return;
            const seatNo = seat.dataset.seat;
            if (seat.classList.contains('selected')) {
                seat.classList.remove('selected');
                selectedSeats.delete(seatNo);
                input.value = '';
                refreshAllSeats(); return;
            }
            card.querySelectorAll('.seat.selected').forEach(s => { selectedSeats.delete(s.dataset.seat); s.classList.remove('selected'); });
            seat.classList.add('selected');
            input.value = seatNo;
            selectedSeats.add(seatNo);
            refreshAllSeats();
        });
    });
});
function refreshAllSeats() {
    document.querySelectorAll('.seat').forEach(seat => {
        if (seat.classList.contains('selected')) return;
        seat.classList.toggle('disabled', selectedSeats.has(seat.dataset.seat));
    });
}

const s = document.getElementById('stars');
for (let i = 0; i < 80; i++) {
    const el = document.createElement('div'); el.className = 'star';
    const sz = Math.random() * 2 + .5;
    el.style.cssText = `width:${sz}px;height:${sz}px;top:${Math.random()*100}%;left:${Math.random()*100}%;--dur:${2+Math.random()*4}s;--delay:${Math.random()*5}s;--op:${.3+Math.random()*.5};`;
    s.appendChild(el);
}
document.querySelectorAll('.field-wrap input, .field-wrap select').forEach(el => {
    el.addEventListener('focus', function() {
        const ic = this.parentElement.querySelector('.field-icon');
        if (ic) ic.style.color = '#4D8AFF';
    });
    el.addEventListener('blur', function() {
        const ic = this.parentElement.querySelector('.field-icon');
        if (ic) ic.style.color = 'rgba(255,255,255,.2)';
    });
});
</script>
</body>
</html>
