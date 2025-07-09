namespace TrikiApi.Models
{
    public class RegisterDto
    {
        public string Username { get; set; } = "";
        public string Password { get; set; } = "";
        public string Role { get; set; } = "client";
        public string? Phone { get; set; } // ✅ Ajouté
    }
}
