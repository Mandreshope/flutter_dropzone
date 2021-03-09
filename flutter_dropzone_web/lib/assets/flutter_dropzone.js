if (typeof FlutterDropzone === 'undefined') {
  class FlutterDropzone {
    constructor(container, onLoaded, onError, onHover, onDrop, onImgDrop, onLeave) {
      this.onHover = onHover;
      this.onDrop = onDrop;
      this.onImgDrop = onImgDrop;
      this.onLeave = onLeave;
      this.dropMIME = null;
      this.dropOperation = 'copy';
  
      container.addEventListener('dragover', this.dragover_handler.bind(this));
      container.addEventListener('dragleave', this.dragleave_handler.bind(this));
      container.addEventListener('drop', this.drop_handler.bind(this));
      container.addEventListener('drop', this.imgDrop_handler.bind(this))
  
      if (onLoaded != null) onLoaded();
    }
  
    dragover_handler(event) {
      event.preventDefault();
      event.dataTransfer.dropEffect = this.dropOperation;
      if (this.onHover != null) this.onHover(event);
    }
  
    dragleave_handler(event) {
      event.preventDefault();
      if (this.onLeave != null) this.onLeave(event);
    }

    imgDrop_handler(event) {

      event.preventDefault();
  
      var os = getOS();

      var imageUrl;
      if(os == 'Windows') {
        imageUrl = event.dataTransfer.getData('Text');
      }else if(os == 'Mac OS'){
        imageUrl = event.dataTransfer.getData('URL');
      }
      this.onImgDrop(event, imageUrl);
    }
  
    drop_handler(event) {

      event.preventDefault();

      if (event.dataTransfer.items) {
        for (var i = 0; i < event.dataTransfer.items.length; i++) {
          var item = event.dataTransfer.items[i];
          var match = (item.kind === 'file');
          if (this.dropMIME != null && !this.dropMIME.includes(item.mime))
            match = false;
  
          if (match) {
            var file = event.dataTransfer.items[i].getAsFile();
            this.onDrop(event, file);
          }
        }
      } else {
        for (var i = 0; i < ev.dataTransfer.files.length; i++) {
          this.onDrop(event, event.dataTransfer.files[i]);
        }
      }
    }
  
    setMIME(mime) {
      this.dropMIME = mime;
    }
  
    setOperation(operation) {
      this.dropOperation = operation;
    }
  }
  
  var flutter_dropzone_web = {
    isCanvasKit: function() {
      return window.flutterCanvasKit != null;
    },
  
    setMIME: function(container, mime) {
      container.FlutterDropzone.setMIME(mime);
    },
  
    setOperation: function(container, operation) {
      container.FlutterDropzone.setOperation(operation);
    },
  
    setCursor: function(container, cursor) {
      container.style.cursor = cursor;
    },
  
    create: function(container, onLoaded, onError, onHover, onDrop, onImgDrop, onLeave) {
      container.FlutterDropzone = new FlutterDropzone(container, onLoaded, onError, onHover, onDrop, onImgDrop, onLeave);
    },
  };
  
  window.dispatchEvent(new Event('flutter_dropzone_web_ready'));
  }
  
  function getOS() {
    var userAgent = window.navigator.userAgent,
        platform = window.navigator.platform,
        macosPlatforms = ['Macintosh', 'MacIntel', 'MacPPC', 'Mac68K'],
        windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
        iosPlatforms = ['iPhone', 'iPad', 'iPod'],
        os = null;
  
    if (macosPlatforms.indexOf(platform) !== -1) {
      os = 'Mac OS';
    } else if (iosPlatforms.indexOf(platform) !== -1) {
      os = 'iOS';
    } else if (windowsPlatforms.indexOf(platform) !== -1) {
      os = 'Windows';
    } else if (/Android/.test(userAgent)) {
      os = 'Android';
    } else if (!os && /Linux/.test(platform)) {
      os = 'Linux';
    }
  
    return os;
  }