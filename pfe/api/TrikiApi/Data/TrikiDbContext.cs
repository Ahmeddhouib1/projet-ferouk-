using Microsoft.EntityFrameworkCore;
using TrikiApi.models;
using TrikiApi.Models;

namespace TrikiApi.Data
{
  public class TrikiDbContext : DbContext
  {
    public TrikiDbContext(DbContextOptions<TrikiDbContext> options) : base(options) { }

    public DbSet<Product> Products { get; set; }
    public DbSet<User> Users { get; set; }
    public DbSet<CartItem> CartItems { get; set; }
    public DbSet<Order> Orders { get; set; }
    public DbSet<OrderItem> OrderItems { get; set; }
    public DbSet<Wholesaler> Wholesalers { get; set; }



    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      base.OnModelCreating(modelBuilder);

      // Supprimer cascade explicite sur OrderItems → Product
      modelBuilder.Entity<OrderItem>()
          .HasOne(oi => oi.Product)
          .WithMany(p => p.OrderItems)
          .HasForeignKey(oi => oi.ProductId)
          .OnDelete(DeleteBehavior.Restrict); // empêche cascade

      // Tu peux aussi faire ça pour CartItems si besoin :
      modelBuilder.Entity<CartItem>()
          .HasOne(ci => ci.Product)
          .WithMany()
          .HasForeignKey(ci => ci.ProductId)
          .OnDelete(DeleteBehavior.Cascade); // celui-ci reste cascade
    }

  }
}
