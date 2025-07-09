using TrikiApi.Data;
using TrikiApi.Models;

namespace TrikiApi.Data
{
    public static class DbInitializer
    {
        public static void Initialize(TrikiDbContext context)
        {
            context.Database.EnsureCreated();

            if (context.Products.Any())
                return; // DB déjà remplie

            var products = new List<Product>
            {
                new Product
                {
                    Name = "Halwa Authentique",
                    Description = "Halwa tunisienne traditionnelle au goût pur.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/commons/1/1b/Halwa_Turkish_Style.jpg",
                    Price = 4.50,
                    Category = "Halwa"
                },
                new Product
                {
                    Name = "Bonbons Haribo Goldbären",
                    Description = "Bonbons gélifiés populaires en forme d’oursons.",
                    ImageUrl = "https://www.haribo.com/fileadmin/_processed_/0/5/csm_goldbaeren_100g_4e604dd540.png",
                    Price = 3.90,
                    Category = "Bonbons"
                },
                new Product
                {
                    Name = "Chupa Chups Lollipop",
                    Description = "Sucette classique avec goût fruité.",
                    ImageUrl = "https://www.lapapillote.com/7541-large_default/chupa-chups-lolly.jpg",
                    Price = 0.60,
                    Category = "Bonbons sucettes"
                },
                new Product
                {
                    Name = "Chewing-gum Malabar",
                    Description = "Chewing-gum iconique avec tatouage à l'intérieur.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/commons/4/49/Malabar_fraise.jpg",
                    Price = 0.45,
                    Category = "Chewing-gum"
                },
                new Product
                {
                    Name = "Tablette Milka",
                    Description = "Chocolat au lait tendre de la marque Milka.",
                    ImageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Milka_Alpenmilch.jpg/800px-Milka_Alpenmilch.jpg",
                    Price = 6.00,
                    Category = "Bonbons durs"
                }
            };

            context.Products.AddRange(products);
            context.SaveChanges();
        }
    }
}
