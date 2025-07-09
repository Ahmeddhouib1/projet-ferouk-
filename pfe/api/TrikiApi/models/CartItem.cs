using System.Text.Json.Serialization;
using TrikiApi.Models; // ✅ NÉCESSAIRE

public class CartItem
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public int ProductId { get; set; }

    [JsonIgnore]
    public Product? Product { get; set; } // ✅ nullable ici

    public int Quantity { get; set; }
}
