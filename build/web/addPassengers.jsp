<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) { response.sendRedirect("login.jsp"); return; }

    Integer seatsObj = (Integer) session.getAttribute("numSeats");
    int numSeats = (seatsObj == null) ? 1 : seatsObj;

    String bookingId = request.getParameter("bookingId");
    if (bookingId == null) { response.sendRedirect("userDashboard"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Passengers - SkyConnect</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4ff; color: #222; }

        /* NAVBAR */
        .navbar {
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            padding: 14px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .navbar .brand { color: #fff; font-size: 22px; font-weight: 700; text-decoration: none; }
        .nav-links a {
            color: #fff; text-decoration: none; margin-left: 22px;
            font-size: 14px; font-weight: 500; opacity: 0.9;
        }
        .nav-links a:hover { opacity: 1; text-decoration: underline; }

        .container { max-width: 820px; margin: 36px auto; padding: 0 20px; }

        /* PAGE TITLE */
        .page-title {
            font-size: 22px;
            font-weight: 700;
            color: #1a56db;
            margin-bottom: 24px;
        }

        /* PASSENGER CARD */
        .passenger-card {
            background: #fff;
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 22px;
            box-shadow: 0 6px 22px rgba(0,0,0,0.08);
            border-top: 4px solid #1a56db;
        }
        .passenger-card h5 {
            font-size: 16px;
            font-weight: 700;
            color: #1a56db;
            margin-bottom: 20px;
        }

        /* FORM GRID */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .form-grid .full { grid-column: 1 / -1; }

        .form-group { display: flex; flex-direction: column; }
        .form-group label {
            font-size: 12px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .form-group input,
        .form-group select {
            padding: 10px 14px;
            border: 1.5px solid #d1d9f0;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            background: #fafbff;
            transition: border-color 0.2s;
        }
        .form-group input:focus,
        .form-group select:focus {
            border-color: #1a56db;
            background: #fff;
        }
        .form-group input[readonly] {
            background: #f0f4ff;
            color: #555;
            cursor: not-allowed;
        }

        /* SEAT MAP */
        .seat-section {
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1.5px dashed #dde3f5;
        }
        .seat-section label {
            font-size: 13px;
            font-weight: 700;
            color: #444;
            margin-bottom: 12px;
            display: block;
        }
        .seat-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 8px;
        }
        .seat {
            width: 52px;
            height: 44px;
            border-radius: 8px;
            border: 1.5px solid #1a56db;
            background: #fff;
            color: #1a56db;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.18s;
            user-select: none;
        }
        .seat:hover { background: #eef4ff; }
        .seat.selected {
            background: #1a56db;
            color: #fff;
            border-color: #1a56db;
        }
        .seat.disabled {
            background: #e5e7eb;
            color: #9ca3af;
            border-color: #d1d5db;
            cursor: not-allowed;
        }
        .seat-hint {
            font-size: 12px;
            color: #888;
            margin-top: 4px;
        }

        /* SUBMIT */
        .submit-row {
            display: flex;
            justify-content: flex-end;
            margin-top: 10px;
        }
        .btn-submit {
            padding: 13px 36px;
            background: linear-gradient(90deg, #1a56db, #0ea5e9);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.1s;
        }
        .btn-submit:hover { opacity: 0.92; transform: translateY(-1px); }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="userDashboard" class="brand">✈ SkyConnect</a>
    <div class="nav-links">
        <a href="userDashboard">Dashboard</a>
        <a href="userBookings">My Bookings</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="page-title">👥 Add Passenger Details</div>

    <form action="savePassengers" method="post">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">

        <% for (int i = 1; i <= numSeats; i++) { %>
        <div class="passenger-card">
            <h5>✈ Passenger <%= i %></h5>

            <div class="form-grid">

                <!-- FULL NAME -->
                <div class="form-group full">
                    <label>Full Name</label>
                    <input type="text" name="full_name[]" placeholder="Enter full name" required>
                </div>

                <!-- DOB -->
                <div class="form-group">
                    <label>Date of Birth</label>
                    <input type="date" name="dob[]"
                           class="dob-field"
                           data-age-id="age<%= i %>"
                           required>
                </div>

                <!-- AGE (auto) -->
                <div class="form-group">
                    <label>Age (auto-filled)</label>
                    <input type="number" name="age[]"
                           id="age<%= i %>"
                           placeholder="Auto" readonly required>
                </div>

                <!-- GENDER -->
                <div class="form-group">
                    <label>Gender</label>
                    <select name="gender[]" required>
                        <option value="">Select</option>
                        <option value="MALE">Male</option>
                        <option value="FEMALE">Female</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>

                <!-- PHONE -->
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="phone[]" placeholder="Mobile number">
                </div>

                <!-- EMAIL -->
                <div class="form-group full">
                    <label>Email</label>
                    <input type="email" name="email[]" placeholder="passenger@email.com">
                </div>

            </div>

            <!-- SEAT SELECTION -->
            <div class="seat-section">
                <label>🪑 Select Seat <span style="font-weight:400;color:#888;">(optional — leave empty to auto-assign)</span></label>

                <input type="hidden" name="seat_no[]" class="seat-input">

                <div class="seat-grid">
                    <%
                        String[] seatList = {
                            "A1","A2","A3","A4","A5","A6",
                            "B1","B2","B3","B4","B5","B6",
                            "C1","C2","C3","C4","C5","C6",
                            "D1","D2","D3","D4","D5","D6"
                        };
                        for (String s : seatList) {
                    %>
                        <div class="seat" data-seat="<%= s %>"><%= s %></div>
                    <% } %>
                </div>
                <div class="seat-hint">Click a seat to select. Click again to deselect.</div>
            </div>
        </div>
        <% } %>

        <div class="submit-row">
            <button type="submit" class="btn-submit">
                💾 Save & Continue to Payment →
            </button>
        </div>
    </form>
</div>

<script>
// AGE AUTO-CALCULATION
document.querySelectorAll(".dob-field").forEach(dob => {
    dob.addEventListener("change", function () {
        const dobDate = new Date(this.value);
        const today = new Date();
        let age = today.getFullYear() - dobDate.getFullYear();
        const m = today.getMonth() - dobDate.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < dobDate.getDate())) age--;
        const ageInput = document.getElementById(this.dataset.ageId);
        if (ageInput) ageInput.value = age >= 0 ? age : "";
    });
});

// SEAT SELECTION
let selectedSeats = new Set();

document.querySelectorAll(".passenger-card").forEach(card => {
    const input = card.querySelector(".seat-input");

    card.querySelectorAll(".seat").forEach(seat => {
        seat.addEventListener("click", () => {
            if (seat.classList.contains("disabled")) return;

            const seatNo = seat.dataset.seat;

            // Toggle off if already selected in THIS card
            if (seat.classList.contains("selected")) {
                seat.classList.remove("selected");
                selectedSeats.delete(seatNo);
                input.value = "";
                refreshAllSeats();
                return;
            }

            // Deselect old seat in this card
            card.querySelectorAll(".seat.selected").forEach(s => {
                selectedSeats.delete(s.dataset.seat);
                s.classList.remove("selected");
            });

            // Select new
            seat.classList.add("selected");
            input.value = seatNo;
            selectedSeats.add(seatNo);

            refreshAllSeats();
        });
    });
});

function refreshAllSeats() {
    document.querySelectorAll(".seat").forEach(seat => {
        if (seat.classList.contains("selected")) return;
        if (selectedSeats.has(seat.dataset.seat)) {
            seat.classList.add("disabled");
        } else {
            seat.classList.remove("disabled");
        }
    });
}
</script>

</body>
</html>