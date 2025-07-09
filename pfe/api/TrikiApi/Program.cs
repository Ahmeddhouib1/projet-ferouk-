using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using TrikiApi.Data;

var builder = WebApplication.CreateBuilder(args);

// Ajouter services
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Triki API", Version = "v1" });
});

builder.Services.AddDbContext<TrikiDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    });
});

var app = builder.Build();

// DB init si besoin
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<TrikiDbContext>();
    DbInitializer.Initialize(context); // optionnel
}

// Middleware
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "Triki API V1");
});

app.UseCors("AllowAll");

app.UseStaticFiles(); // 👈 Important pour servir les images de wwwroot/images
app.UseHttpsRedirection();
app.UseAuthorization();
app.UseRouting();
app.MapControllers();
app.Run();
