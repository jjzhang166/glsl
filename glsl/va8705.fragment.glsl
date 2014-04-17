#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

//
// @jimhejl
//

void main( void ) {

      vec2 UV = ( gl_FragCoord.xy / resolution.xy );
      UV.y = 1.-UV.y;
      vec2 UVOrig=UV;
      vec4 col4 = vec4(0);
      float col=0.;
 
      if( (UV.x>0.1) &&  (UV.x<=0.9) && (UV.y>0.1) &&  (UV.y<=0.9))
      { 
            UV.xy = (UV.xy - 0.1) * 1.25; // rescale UV because of overscan
 
            if(UV.y<0.2) 
            {
                  float phase =  floor(UV.x *8.999);
                  float even = (fract(phase/2.) > 0.1) ? 0. : 1.;
                  if(even < 0.5)
                  {
                        col =  0.5; 
 
                  } else
                  {
                        col = clamp( fract(float((gl_FragCoord.x)/2.)) > .5 ? 1. : 0., 0.,1.);
                  }
 
                  col4 = vec4(col,col,col,0.);
            }
	    else if(UV.y<0.4)  
            {
		  // 9 swatches, linear
                  col = floor(UV.x *8.999) / 8.;
                  col4 = vec4(col,col,col,0.);
            }
	    else if(UV.y<0.6) 
            {
		  // 9 swatches, gamma 2.2
                  col = floor(UV.x *8.999) / 8.;
                  col = pow(col,0.45);
                  col4 = vec4(col,col,col,0.);
            } 
	    else if(UV.y<0.8)     
            {
		  // gradient, gamma 2.2
                  col = UV.x;
                  col = pow(col,0.45);
                  col4 = vec4(col,col,col,0.);
            }
	    else
            {
		  //  primary and secondary colors
		  if( UV.x < 0.15)
                        col4 = vec4(1.,0.,0.,0.);
                  else if( UV.x < 0.3)
                        col4 = vec4(0.,1.,0.,0.);
                  else if( UV.x < 0.45)
                        col4 = vec4(0.,0.,1.,0.);
                  else if( UV.x < 0.6)
                        col4 = vec4(0.,1.,1.,0.);
                  else if( UV.x < 0.75)
                        col4 = vec4(1.,0.,1.,0.);
                  else if( UV.x < 0.89)
                        col4 = vec4(1.,1.,0.,0.);
                  else
                        col4 = vec4(1.,1.,1.,0.); 
            }
      }
	gl_FragColor = col4;
}