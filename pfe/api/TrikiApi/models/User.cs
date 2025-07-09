namespace TrikiApi.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string Role { get; set; } = "client";
        public string? Phone { get; set; } // ✅ Ajouté
    }
}
