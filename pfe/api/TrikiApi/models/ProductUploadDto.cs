namespace TrikiApi.Models
{
  public class ProductUploadDto
  {
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public double Price { get; set; }
    public string Category { get; set; } = string.Empty;
    public int Stock { get; set; } // ⚠ Ajoute ceci si absent
  }
}
