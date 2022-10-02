using Markdig;

namespace FoxProInterop
{
    public class FirstDotnet
    {
        public string HelloWorld(string name)
        {
            return "Hello World, " + name;
        }

        public string MarkdownToHtml(string markdown)
        {
            if (string.IsNullOrEmpty(markdown))
                return markdown;

            var builder = new MarkdownPipelineBuilder();
            builder = builder.UseAdvancedExtensions();
            builder = builder.UseListExtras();
            var loPipeline = builder.Build();

            var html =  Markdown.ToHtml(markdown, loPipeline);
            return html;
        }

    }

}