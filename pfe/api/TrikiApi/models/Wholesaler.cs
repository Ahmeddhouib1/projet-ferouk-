using TrikiApi.Models;

namespace TrikiApi.models
{
    public class Wholesaler
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string CompanyName { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;

        public User? User { get; set; }
    }
}
