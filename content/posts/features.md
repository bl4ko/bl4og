---
title: "Blog features"
date: 2023-09-22T09:03:20-08:00
description: "This is a simple post showcasing the features of this theme."
draft: true
---
## Blog functions

This is a simple markdown blog with the following functions:

- **bold** text;
- *emphasized* text;
- `inline code`;
- [links](https://gohugo.io);
- images ![Profile](/img/theme-colors/profile.png);

### Writing code

```js
export default function binSearch(arr: int[], num: int): int {
    let low = 0;
    let high = arr.length - 1;
    let mid = 0;

    while (low <= high) {
        mid = Math.floor((low + high) / 2);

        if (arr[mid] === num) {
            return mid;
        } else if (arr[mid] < num) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }

    return -1; 
}
```

Now here is a simple bash script, to find all devices in home network

```bash
#!/bin/bash
devices=$(arp -a | awk '{print $2}' | sed 's/[()]//g' | sort -u)
for device in $devices
do
    echo $device
done
```

## Shortcodes

### Code

Now I am going to test hugo shortcodes. First testing `code` shortcode. It has the following props:

- **language** (required)
- **title** (optional)
- **id** (optional)
- **expand** (optional, default "△")
- **collapse** (optional, default "▽")
- **isCollapsed**

{{< code language="js" title="Binary Search" id="1" expand="Show" collapse="Hide" isCollapsed="false" >}}
export default function binSearch(arr: int[], num: int): int {
    let low = 0;
    let high = arr.length - 1;
    let mid = 0;

    while (low <= high) {
        mid = Math.floor((low + high) / 2);

        if (arr[mid] === num) {
            return mid;
        } else if (arr[mid] < num) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }

    return -1; 
}
{{< /code >}}

### Image

Now I am going to test `image` shortcode. It has the following props:

- **src** (required)
- **alt** (optional)
- **position** (optional, default "left" | center | right)
- **style** (optional)

```plaintext
{{/< image src="/img/theme-colors/profile.png" alt="Profile" position="center" style="border-radius: 8px; width: 300px" >}}
```

{{< image src="/img/theme-colors/profile.png" alt="Profile" position="center" style="border-radius: 8px; width: 300px" >}}

### Figure

Now I am going to test `figure` shortcode, same as image plus few optional props:

- **caption**
- **captionPosition** (left | **center** is default | right)
- **captionStyle**

```plaintext
{{/<figure src="/img/hello.png" alt="Hello Friend" position="center" style="border-radius: 8px;" caption="Hello Friend!" captionPosition="right" captionStyle="color: red;"> }}
```

{{< figure src="/img/theme-colors/profile.png" alt="Hello Friend" position="center" style="border-radius: 8px; width: 300px;" caption="Hello Friend!" captionPosition="right" captionStyle="color: red;" >}}