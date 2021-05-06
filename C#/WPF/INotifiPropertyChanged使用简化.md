### INotifiPropertyChanged使用简化

+ 简化前

~~~C#
      class PictureModel : INotifyPropertyChanged
    {
        private BitmapImage picture;
        public BitmapImage Picture
        {
            get => picture;
            set
            {
                //避免不必要的数据同步
                if (picture != value)
                {
                    picture = value;
                    OnPropertyChanged();
                }
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        public void OnPropertyChanged([CallerMemberName] string parameter = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(parameter));
        }
    }
~~~

  

+ 简化后

~~~C#
    class PictureModel : IPropChanged
    {
        private BitmapImage picture;
        public BitmapImage Picture
        {
            get => picture;
            set
            {
                //避免不必要的数据同步
                if (picture != value)
                {
                    picture = value;
                    OnPropertyChanged();
                }
            }
        }
    }

    //将INotifyPropertyChanged接口重新定义，简化使用方式
    abstract class IPropChanged:INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public void OnPropertyChanged([CallerMemberName] string parameter = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(parameter));
        }
    }
~~~

