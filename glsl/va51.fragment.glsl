// by Weyland Yutani (reworked by iq/rgba)

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;


     

      o+=h*3.0*g;
      v+=h*0.02;
    
    // light (who needs a normal?)
    v*=e(o*-0.125)*vec3(0.145,0.2663,0.03912);

    // ambient occlusion
    float a=0.0;
    for(int q=0;q<100;q++)
    {
       float l = e(o+1.5*vec3(tan(1.1*float(q)),tan(-5.6*float(q)),cos(1.4*float(q))))-m;
       a+=clamp(8.0*l,0.00,1.0);
    }
    v*=a/250.0;
    gl_FragColor=vec4(v,1.0);
}