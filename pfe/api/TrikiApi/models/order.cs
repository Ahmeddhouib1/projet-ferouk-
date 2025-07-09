using System;
using TrikiApi.Models;

namespace TrikiApi.models
{
  public class Order
  {
    public int Id { get; set; }
    public int UserId { get; set; }
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public DateTime Date { get; set; } = DateTime.Now;

    public User? User { get; set; }
    public Product? Product { get; set; }
    public List<OrderItem> Items { get; set; } = new();

    }
}
