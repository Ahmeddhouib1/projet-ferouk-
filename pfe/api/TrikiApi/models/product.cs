namespace TrikiApi.Models
{
  public class Product
  {
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
    public double Price { get; set; }
    public int Stock { get; set; } 
    public string Category { get; set; } = string.Empty;
    public ICollection<OrderItem>? OrderItems { get; set; }    
           }
}
