# Github Guide
## 1、Fork the main repository  
- Go to https://github.com/caicloud/ui
- Click the "Fork" button

## 2、Clone your fork

```
git clone https://github.com/$YOUR_GITHUB_USERNAME/ui.git
cd ui
git remote add upstream 'https://github.com/caicloud/ui.git'
```

## 3、Create a branch and make changes

```sh
git checkout -b **guohui-patch-1**
# 修改代码
```

## 4、Keeping your development fork sync with upstream

```sh
git fetch upstream
git rebase upstream/master
```
禁止提交到公共仓库
```sh
git remote set-url --push upstream no_push
```

## 5、Committing changes to your fork
把修改提交到自己的分支  
```sh
git commit
git push -f origin **guohui-patch-1**
```

## 6、Creating a pull request

1. Visit https://github.com/$YOUR_GITHUB_USERNAME/ui
2. Click the "Compare and pull request" button next to your "myfeature" branch.
3. Create the Pull Request via the web interface
4. If you want to ping someone specifically, use the `@` syntax

## 7、备注
- rebase失败的处理办法
```sh
$git rebase upstream/master
First, rewinding head to replay your work on top of it...
Fast-forwarded guohui-patch-1 to upstream/master.
$git clean -d -fx ""
$git rebase upstream/master
Current branch guohui-patch-1 is up to date.
```

## 8、切换分支
```sh
git checkout branch_name
```

## 9、删除本地分支
```sh
git branch -d branch_name
```

## 10、删除远程分支
```sh
git push origin :branch_name
```
