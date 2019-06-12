using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace My.Fiziq.Sdk.RNMyFiziqSdk
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNMyFiziqSdkModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNMyFiziqSdkModule"/>.
        /// </summary>
        internal RNMyFiziqSdkModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNMyFiziqSdk";
            }
        }
    }
}
