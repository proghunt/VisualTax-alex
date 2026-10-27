{***************************************************************************}
{                                                                           }
{                                                                           }
{ Unit containst interface IShowDocument,                                   }
{     for using this interface for cross-platform implementation            }
{                                                                           }
{***************************************************************************}
unit ShowDocumentInterface;

interface

type

  ///	<summary>
  ///	Inteface shows methods for work with user Documents
  ///	</summary>
  IShowDocument = interface
    ///	<summary>
    ///	Open file with program which assosiated with the file extension
    ///	</summary>
    /// <param name="FileName">
    ///    File for open
    ///	</param>
     procedure ShowDocument(FileName: string);
  end;

implementation

end.
