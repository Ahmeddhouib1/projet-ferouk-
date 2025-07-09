using Microsoft.AspNetCore.Mvc;
using TrikiApi.Models;
using TrikiApi.Data;

namespace TrikiApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductController : ControllerBase
    {
        private readonly TrikiDbContext _context;
        private readonly IWebHostEnvironment _env;

        public ProductController(TrikiDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            var baseUrl = $"{Request.Scheme}://{Request.Host}/";
            var products = _context.Products
                .Select(p => new Product
                {
                    Id = p.Id,
                    Name = p.Name,
                    Description = p.Description,
                    Price = p.Price,
                    Category = p.Category,
                    ImageUrl = p.ImageUrl.StartsWith("http") ? p.ImageUrl : baseUrl + p.ImageUrl
                })
                .ToList();
            return Ok(products);
        }
[HttpDelete("{id}")]
public async Task<IActionResult> DeleteProduct(int id)
{
    var product = await _context.Products.FindAsync(id);
    if (product == null)
        return NotFound();

    // 🔴 Supprimer toutes les lignes dans CartItems où ce produit est utilisé
    var relatedCartItems = _context.CartItems.Where(ci => ci.ProductId == id);
    _context.CartItems.RemoveRange(relatedCartItems);

    // 🔴 Supprimer toutes les lignes dans OrderItems où ce produit est utilisé
    var relatedOrderItems = _context.OrderItems.Where(oi => oi.ProductId == id);
    _context.OrderItems.RemoveRange(relatedOrderItems);

    // ✅ Enfin, supprimer le produit lui-même
    _context.Products.Remove(product);

    await _context.SaveChangesAsync();
    return NoContent();
}


        [HttpPost("upload")]
        public async Task<IActionResult> Upload([FromForm] ProductUploadDto dto, IFormFile image)
        {
            if (image == null || image.Length == 0)
                return BadRequest("Image manquante");

            var uploadsDir = Path.Combine(_env.WebRootPath, "images");
            if (!Directory.Exists(uploadsDir))
                Directory.CreateDirectory(uploadsDir);

            var fileName = Guid.NewGuid().ToString() + Path.GetExtension(image.FileName);
            var filePath = Path.Combine(uploadsDir, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await image.CopyToAsync(stream);
            }

            var product = new Product
            {
              Name = dto.Name,
              Description = dto.Description,
              Price = dto.Price,
              Category = dto.Category,
              ImageUrl = $"images/{fileName}", // relative path
              Stock = dto.Stock
            };

            _context.Products.Add(product);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetAll), new { id = product.Id }, product);
        }
    }
}
