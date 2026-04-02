<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Flight Seat Map</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
.seat {
    width: 55px;
    height: 55px;
    margin: 6px;
    border-radius: 10px;
    font-weight: bold;
    cursor: pointer;
}
.available {
    background: #28a745;
    color: white;
}
.booked {
    background: #dc3545;
    color: white;
    cursor: not-allowed;
}
</style>
</head>

<body>
<div class="container mt-5">
<h4 class="text-center mb-4">✈ Flight Seat Map</h4>

<input type="hidden" id="flightId" value="<%= request.getParameter("flightId") %>">

<div class="text-center">
    <div>
        <button class="seat available" id="A1">A1</button>
        <button class="seat available" id="A2">A2</button>
        <button class="seat available" id="A3">A3</button>
    </div>
    <div class="mt-2">
        <button class="seat available" id="B1">B1</button>
        <button class="seat available" id="B2">B2</button>
        <button class="seat available" id="B3">B3</button>
    </div>
</div>
</div>

<script>
fetch("getSeatMap?flightId=" + document.getElementById("flightId").value)
.then(res => res.json())
.then(data => {
    data.forEach(seat => {
        let s = document.getElementById(seat);
        if (s) {
            s.classList.remove("available");
            s.classList.add("booked");
            s.disabled = true;
        }
    });
});
</script>

</body>
</html>