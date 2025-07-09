using Microsoft.AspNetCore.Mvc;
using TrikiApi.Models;
using TrikiApi.Data;

namespace TrikiApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly TrikiDbContext _context;

        public AuthController(TrikiDbContext context)
        {
            _context = context;
        }

      [HttpPost("register")]
public IActionResult Register([FromBody] RegisterDto dto)
{
    var existing = _context.Users.FirstOrDefault(u => u.Username == dto.Username);
    if (existing != null)
        return BadRequest("Nom d'utilisateur déjà pris");

    var user = new User
    {
        Username = dto.Username,
        Password = dto.Password,
        Role = dto.Role,
        Phone = dto.Phone // ✅ Ajouté
    };

    _context.Users.Add(user);
    _context.SaveChanges();

    return Ok();
}



        [HttpPost("login")]
        public IActionResult Login(User user)
        {
            var found = _context.Users.FirstOrDefault(u =>
                u.Username == user.Username && u.Password == user.Password);

            if (found == null)
                return Unauthorized("Identifiants invalides");

            return Ok(new { found.Id, found.Username, found.Role });
        }
    }
}
