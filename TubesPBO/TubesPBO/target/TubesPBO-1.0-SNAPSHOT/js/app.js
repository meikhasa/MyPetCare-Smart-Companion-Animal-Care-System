/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// app.js
// Global JavaScript untuk TubesPBO / MyPetCare

document.addEventListener("DOMContentLoaded", function () {

    // ===== ALERT ERROR LOGIN =====
    const params = new URLSearchParams(window.location.search);
    if (params.get("error") === "invalid_login") {
        alert("Username atau password salah!");
    }

    // ===== KONFIRMASI HAPUS DATA =====
    const deleteButtons = document.querySelectorAll(".btn-delete");
    deleteButtons.forEach(button => {
        button.addEventListener("click", function (e) {
            const confirmDelete = confirm("Yakin ingin menghapus data ini?");
            if (!confirmDelete) {
                e.preventDefault();
            }
        });
    });

});


