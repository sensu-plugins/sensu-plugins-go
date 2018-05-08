// Copyright © 2016 Anthony Spring <aspring@yieldbot.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package version

import (
	"fmt"
)

//AppVersionMajor is the major revision number
const AppVersionMajor = "0"

// AppVersionMinor is the minor revison number
const AppVersionMinor = "0"

// AppVersionPatch is the patch version
const AppVersionPatch = "1"

// AppVersionPre ...
const AppVersionPre = ""

// AppVersionBuild should be empty string when releasing
const AppVersionBuild = ""

// AppVersion generates a usable version string
func AppVersion() string {
	return fmt.Sprintf("%s.%s.%s%s%s", AppVersionMajor, AppVersionMinor, AppVersionPatch, AppVersionPre, AppVersionBuild)
}

func main() {
	fmt.Printf("%s", AppVersion())
}
