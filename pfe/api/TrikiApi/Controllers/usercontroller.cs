using Microsoft.AspNetCore.Mvc;
using TrikiApi.Data;
using TrikiApi.Models;

namespace TrikiApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly TrikiDbContext _context;

        public UserController(TrikiDbContext context)
        {
            _context = context;
        }

        [HttpGet("role/{role}")]
public IActionResult GetUsersByRole(string role)
{
    var users = _context.Users
        .Where(u => u.Role == role)
        .Select(u => new {
            u.Id,
            u.Username,
            u.Role,
            u.Phone // ✅ Assure-toi que cette ligne est présente
        })
        .ToList();

    return Ok(users);
}


        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, [FromBody] User updatedUser)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

         user.Username = updatedUser.Username;
            user.Role = updatedUser.Role;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
