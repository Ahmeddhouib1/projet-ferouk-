using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TrikiApi.Data;
using TrikiApi.models;
using TrikiApi.Models;

namespace TrikiApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CartController : ControllerBase
    {
        private readonly TrikiDbContext _context;
        private readonly IWebHostEnvironment _env;

        public CartController(TrikiDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        [HttpGet("{userId}")]
        public IActionResult GetCart(int userId)
        {
            var cart = _context.CartItems
                .Include(c => c.Product)
                .Where(c => c.UserId == userId)
                .Select(c => new CartItemDto
                {
                    Id = c.Id,
                    ProductId = c.ProductId,
                    ProductName = c.Product!.Name,
                    ProductImageUrl = c.Product.ImageUrl.StartsWith("http")
                        ? c.Product.ImageUrl
                        : $"http://{Request.Host}/{c.Product.ImageUrl}",
                    Price = (decimal)c.Product.Price,
                    Quantity = c.Quantity
                })
                .ToList();

            return Ok(cart);
        }

        [HttpPost]
        public IActionResult AddToCart([FromBody] CartItem item)
        {
            var userExists = _context.Users.Any(u => u.Id == item.UserId);
            var product = _context.Products.Find(item.ProductId);

            if (!userExists || product == null)
                return BadRequest("User or product does not exist.");

            var existing = _context.CartItems
                .Include(c => c.Product)
                .FirstOrDefault(c => c.UserId == item.UserId && c.ProductId == item.ProductId);

            if (existing != null)
            {
                existing.Quantity += item.Quantity;
            }
            else
            {
                item.Product = product;
                _context.CartItems.Add(item);
            }

            _context.SaveChanges();

            // ✅ Ajouter automatiquement une commande (Order) à chaque ajout au panier
            var newOrder = new Order
            {
                UserId = item.UserId,
                Items = new List<OrderItem>
                {
                    new OrderItem
                    {
                        ProductId = item.ProductId,
                        Quantity = item.Quantity,
Price = (decimal)product.Price
                    }
                }
            };
            _context.Orders.Add(newOrder);
            _context.SaveChanges();

            return Ok();
        }

        [HttpDelete("{id}")]
        public IActionResult RemoveItem(int id)
        {
            var item = _context.CartItems.Find(id);
            if (item == null) return NotFound();

            _context.CartItems.Remove(item);
            _context.SaveChanges();
            return NoContent();
        }

        [HttpDelete("clear/{userId}")]
        public IActionResult ClearCart(int userId)
        {
            var items = _context.CartItems.Where(c => c.UserId == userId).ToList();
            _context.CartItems.RemoveRange(items);
            _context.SaveChanges();
            return NoContent();
        }
    }
}
