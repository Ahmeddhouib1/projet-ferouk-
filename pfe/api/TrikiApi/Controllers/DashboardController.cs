using Microsoft.AspNetCore.Mvc;
using TrikiApi.Data;

namespace TrikiApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DashboardController : ControllerBase
    {
        private readonly TrikiDbContext _context;

        public DashboardController(TrikiDbContext context)
        {
            _context = context;
        }

        [HttpGet("stats")]
        public IActionResult GetStats()
        {
            var totalClients = _context.Users.Count(u => u.Role == "client");
            var totalWholesalers = _context.Users.Count(u => u.Role == "grossiste");

            var products = _context.Products.ToList();
            var cartItems = _context.CartItems.ToList();

            var stockParCategorie = products
                .GroupBy(p => p.Category)
                .Select(g => new
                {
                    category = g.Key,
                    products = g.Select(p =>
                    {
                        var inCart = cartItems.Where(ci => ci.ProductId == p.Id).Sum(ci => ci.Quantity);
                        return new
                        {
                            name = p.Name,
                            initialStock = p.Stock,
                            stockInCart = inCart,
                            stockDisponible = p.Stock - inCart
                        };
                    }).ToList()
                }).ToList();

            var ventesParCategorie = products
                .GroupBy(p => p.Category)
                .Select(g => new
                {
                    category = g.Key,
                    totalVentes = cartItems
                        .Where(ci => g.Select(p => p.Id).Contains(ci.ProductId))
                        .Sum(ci => ci.Quantity)
                }).ToList();

            return Ok(new
            {
                totalClients,
                totalWholesalers,
                stockParCategorie,
                ventesParCategorie
            });
        }
    }
}
