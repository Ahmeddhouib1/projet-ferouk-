using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Net.Mail;

namespace YourApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailController : ControllerBase
    {
        [HttpPost]
        public IActionResult SendEmail([FromBody] EmailRequest request)
        {
            try
            {
                var fromAddress = new MailAddress("ahmeddhouib475@gmail.com", "Contact Triki");
                var toAddress = new MailAddress("ahmeddhouib475@gmail.com");
                const string fromPassword = "drgx jllq pnsz vcgd"; // Mot de passe d'application Gmail

                string subject = $"Message de {request.Name}";
                string body = $"Nom : {request.Name}\nEmail : {request.Email}\n\nMessage :\n{request.Message}";

                var smtp = new SmtpClient
                {
                    Host = "smtp.gmail.com",
                    Port = 587,
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
                };

                using var message = new MailMessage(fromAddress, toAddress)
                {
                    Subject = subject,
                    Body = body,
                };

                // ✅ Permet de répondre à l’adresse saisie dans le formulaire
                message.ReplyToList.Add(new MailAddress(request.Email));

                smtp.Send(message);
                return Ok("Mail envoyé !");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Erreur d’envoi : {ex.Message}");
            }
        }
    }

    public class EmailRequest
    {
        public string Name { get; set; } = "";
        public string Email { get; set; } = "";
        public string Message { get; set; } = "";
    }
}
