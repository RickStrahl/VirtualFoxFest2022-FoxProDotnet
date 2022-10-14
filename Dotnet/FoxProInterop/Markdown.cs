using Markdig;

namespace FoxProInterop
{
    public class Markdown
    {
        private static MarkdownPipeline pipeline { get; set; }

        static Markdown()
        {

            var builder = new MarkdownPipelineBuilder()
            .UseAdvancedExtensions()
            .UseDiagrams()
            .UseGenericAttributes();

            pipeline = builder.Build();
        }

        public static string ToHtml(string markdownText)
        {
            return Markdig.Markdown.ToHtml(markdownText, pipeline, null);
        }
    }
        
}