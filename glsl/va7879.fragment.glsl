#ifdef GL_ES
precision highp float;
#endif

 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;

 lowp vec3 inputColor = vec3(1.0, 1.0, 1.0);
 lowp vec3 outputColor = vec3(0.5, 0.5, 0.5);

 void main()
 {
     lowp vec3 tc = vec3(0.0, 0.0, 0.0);
    
    lowp vec4 pixcol = texture2D(inputImageTexture, textureCoordinate).rgba;
    
    if (pixcol.a >= 0.2) {
        lowp vec3 sample = inputColor;
        lowp vec3 texel = pixcol.rgb;
        
        bool result = true;
        if ( abs(texel.r-sample.r) > 0.1 ) {
            result = false;
        }
        if ( abs(texel.g-sample.g) > 0.1 ) {
            result = false;
        }
        if ( abs(texel.b-sample.b) > 0.1 ) {
            result = false;
        }
        
        if (result)
            tc = outputColor;
        else 
            tc = pixcol.rgb;
    }
    else
        tc = pixcol.rgb;
     
     
    
    gl_FragColor = vec4(tc.rgb, pixcol.a);

 }