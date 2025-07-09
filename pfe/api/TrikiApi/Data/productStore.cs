using TrikiApi.Models;

namespace TrikiApi.Data
{
    public static class ProductStore
    {
        public static List<Product> Products = new()
        {
            new Product { Id = 1, Name = "Halwa Triki", Description = "Halwa traditionnelle au sésame", ImageUrl = "https://example.com/halwa.jpeg", Price = 5.5, Category = "Halwa" },
            new Product { Id = 2, Name = "Power Boom", Description = "Bonbon explosif", ImageUrl = "https://example.com/powerboom.jpeg", Price = 0.5, Category = "Bonbons" },
            new Product { Id = 3, Name = "Bubble Gum Max", Description = "Chewing-gum à la fraise", ImageUrl = "https://example.com/bubblegum.jpeg", Price = 0.3, Category = "Bubble gum" }
        };
    }
}
