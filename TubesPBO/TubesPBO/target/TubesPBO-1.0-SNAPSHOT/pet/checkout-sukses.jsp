<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Checkout Berhasil | MyPetCare</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f8f9fa;
                margin: 0;
            }
            .header {
                background-color: #6221ff;
                color: white;
                padding: 20px 40px;
                font-size: 18px;
            }
            .container {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 80vh;
            }
            .success-card {
                background: white;
                padding: 50px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                text-align: center;
                max-width: 600px;
                width: 90%;
            }
            .icon-check {
                color: #2ecc71;
                font-size: 80px;
                margin-bottom: 20px;
            }
            h2 {
                color: #2ecc71;
                margin-bottom: 10px;
            }
            p {
                color: #666;
                margin-bottom: 30px;
                line-height: 1.6;
            }
            .btn-group {
                display: flex;
                justify-content: center;
                gap: 15px;
            }
            .btn {
                padding: 12px 25px;
                border-radius: 10px;
                text-decoration: none;
                font-weight: bold;
                transition: 0.3s;
            }
            .btn-primary {
                background: #6221ff;
                color: white;
            }
            .btn-primary:hover {
                background: #4b18cc;
            }
            .btn-secondary {
                background: #e0e0e0;
                color: #333;
            }
            .btn-secondary:hover {
                background: #d0d0d0;
            }
        </style>
    </head>
    <body>
        <div class="header">Checkout Berhasil</div>
        <div class="container">
            <div class="success-card">
                <div class="icon-check"><i class="fa-regular fa-circle-check"></i></div>
                <h2>Pesanan Berhasil!</h2>
                <p>Terima kasih telah berbelanja. Pesanan Anda sedang diproses.</p>
                <div class="btn-group">
                    <a href="<%= request.getContextPath()%>/belanja" class="btn btn-primary">Belanja Lagi</a>
                    <a href="<%= request.getContextPath()%>/dashboard-owner" class="btn btn-secondary">Kembali ke Dashboard</a>
                </div>
            </div>
        </div>
    </body>
</html>