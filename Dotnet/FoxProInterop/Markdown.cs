using Markdig;
using Markdig.Extensions.AutoLinks;

namespace FoxProInterop
{
    public class Markdown
    {

        public static string ToHtml(string markdown)
        {
            var builder = new Markdig.MarkdownPipelineBuilder();
            builder = builder.UseAdvancedExtensions();
           var pipeline = builder.Build();

            return Markdig.Markdown.ToHtml(markdown, pipeline, null);
        }

    }

}