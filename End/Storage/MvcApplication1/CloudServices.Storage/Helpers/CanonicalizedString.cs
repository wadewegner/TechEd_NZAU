namespace MvcApplication1.CloudServices.Storage.Helpers
{
    using System.Text;

    internal class CanonicalizedString
    {
        private readonly StringBuilder canonicalizedString = new StringBuilder();

        internal CanonicalizedString(string initialElement)
        {
            this.canonicalizedString.Append(initialElement);
        }

        internal string Value
        {
            get
            {
                return this.canonicalizedString.ToString();
            }
        }

        internal void AppendCanonicalizedElement(string element)
        {
            this.canonicalizedString.Append("\n");
            this.canonicalizedString.Append(element);
        }
    }
}
