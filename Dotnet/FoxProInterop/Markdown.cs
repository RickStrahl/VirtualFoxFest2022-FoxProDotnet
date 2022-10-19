using Markdig;

namespace FoxProInterop
{
    public class Markdown
    {
        // cached pipeline
        private static MarkdownPipeline Pipeline { get; set; }

        // static constructor runs EXACTLY ONCE on first access of a static member
        static Markdown()
        {
            var builder = new MarkdownPipelineBuilder()
                            .UseAdvancedExtensions()
                            .UseDiagrams()
                            .UseGenericAttributes();
        
            // create and cache the pipeline
            Pipeline = builder.Build();
        }

        public static string ToHtml(string markdownText)
        {   
            return Markdig.Markdown.ToHtml(markdownText, Pipeline, null);
        }
    }
}