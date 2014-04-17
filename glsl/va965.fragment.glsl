#ifdef GL_ES
precision highp float;
precision highp int;
#endif

uniform float time;
vec2 resolution = vec2(sin(time) * 1000. + 1.,cos(time) * 1000. + 1.);
uniform vec4 mouse;

float stack[8];
int stack_length = 0;

// "Index expression must be constant" is complete BS.
void push(float v) {
  if (stack_length==0) { stack[0] = v; }
  if (stack_length==1) { stack[1] = v; }
  if (stack_length==2) { stack[2] = v; }
  if (stack_length==3) { stack[3] = v; }
  if (stack_length==4) { stack[4] = v; }
  if (stack_length==5) { stack[5] = v; }
  stack_length +=1;
}

float pop() {
  stack_length -=1;
  if (stack_length==0) { return stack[0]; }
  if (stack_length==1) { return stack[1]; }
  if (stack_length==2) { return stack[2]; }
  if (stack_length==3) { return stack[3]; }
  if (stack_length==4) { return stack[4]; }
  if (stack_length==5) { return stack[5]; }
}


// this is oh so very sad.
int mod_op(int a, int b) {
    return int(mod(float(a), float(b)));
}

int xor_op(int a, int b) {
    bool flip = false;
    if (a<0) {
      flip = !flip;
      a = -a-1;
    }
    if (b<0) {
      flip = !flip;
      b = -b-1;
    }
    int n = 1;
    int result = 0;
    for(int x=1;x!=0;x++) {
        if (a == 0 && b == 0) {
           if (flip) {
             result = -result-1;
           }
           return result;
        }
        if(mod_op(a, 2) != mod_op(b, 2)) {
            result += n;
        }
        a /= 2;
        b /= 2;
        n *= 2;
    }
    return 0;
}

int or_op(int a, int b) {
    bool flip = false;
    if (a<0) {
      flip = !flip;
      a = -a-1;
    }
    if (b<0) {
      flip = !flip;
      b = -b-1;
    }
    int n =1;
    int result = 0;
    for(int x=1;x!=0;x++) {
        if (a == 0 && b == 0) {
           if (flip) {
             result = -result-1;
           }
           return result;
        }
        if (mod_op(a,2)==1 || mod_op(b, 2)==1) {
             result += n;
        }
        a /= 2;
        b /= 2;
        n *= 2;
    }
    return 0;
}

int log_rshift(int a, int b) {
  float fa = float(a);
  if (a<0) {
    fa += 256.*256.*256.*256.;
  }
  for (int x=1;x!=0;x++) {
    if (b<=0) { return int(fa); }
    fa = floor(fa/2.);
    b -= 1;
  }
  return 0;
}
// very likely to be broken
int lshift(int a, int b) {
  if (b==0 || b==32) return a;
  for (int x=1;x!=0;x++){
    if (b<=0) { return a; }
    a *= 2;
    b -= 1;
  }
  return 0;
}
// hence broken too.
int fp_rot(int a, int b) {
  return or_op(log_rshift(a,b), lshift(a,32-b));
}

int fp_mul(int a, int b) {
    return a*b/256/256;
}
int fp_div(int a, int b) {
    return (a*256*256)/b;
}
int fp_atan(int a, int b) {
    const float PI = 3.141592653589793;
    return int(atan(float(a),float(b))*(32768./PI));
}

void main(void)
{
    // puts x and y in the -1;1 range
    vec2 p = (2.0*gl_FragCoord.xy-resolution)/resolution.y;
    // same with mouse input
    vec2 m = (2.0*mouse.xy-resolution)/resolution.y;

    // flip y
    p.y = -p.y;

    // fixed point versions:
    ivec2 pi = ivec2(int(p.x*65536.),int(p.y*65536.));
    int itime = int(time*30.*65536.);

    // ibniz source: "/*"
    //int a = fp_div(pi.y,pi.x);
    //int videoout = fp_mul(a, itime);

    // ibniz source: "**"
    //int videoout = fp_mul( fp_mul(itime, pi.x), pi.y);

    // ibniz source: "ax8r+3lwd*xd*+q1x/x6r+^"
	
    // fixed point version
    // (rot ops are replaced by shift ops.)
    int v1 = fp_atan(pi.x, pi.y);
    int v2 = itime/256 + v1; //fp_rot(itime,8) + v1;
    v2 = v2 *8;
    int v4 = fp_mul(pi.x, pi.x);
    int v5 = fp_mul(pi.y, pi.y);
    int v6 = v5 + v4;
    int v7 = int(sqrt(max(0.,float(v6)/65536.))*65536.);
    int v8 = 256;
    int v9 = fp_div(v8*256, v7);
    int v10 = itime/64 + v9;
    int v11 = xor_op(v2, v10);
    int videoout = v11;
/*
    // floating point version (likely fastest. some shortcuts taken.)
    float f1 = atan(p.x, p.y)/3.1415926535/2.;
    float f2 = (time*30.)/256. + f1;
    f2 = f2 * 8.;
    float f7 = length(p);
    float f9 = 1./f7;
    float f10 = (time*30.)/64. + f9;
    videoout = xor_op( int(f2*65536.), int(f10*65536.) );

    // floating point, using a stack, mimicking execJS's generated code.
    float a,top;
    push(time*30.); push(p.y); push(p.x); // pushmedia
    top = pop();
    top = atan(top, pop())/(2.*3.14159265);
    a = pop(); push(top);
    top = a;
    top = top/256. + pop();
    push(top*8.);
    push(time*30.); push(p.y); push(p.x); // pushmedia
    top = pop();
    push(top);
    top = top*pop();
    a = pop(); push(top);
    top = a;
    push(top);
    top = top*pop();
    top = top+pop();
    push(sqrt(top));
    a = pop(); push(1.);
    top = pop()/a;
    a = pop(); push(top);
    top = a;
    top = top/64. + pop();
    top = float(xor_op( int(top*65536.), int(pop()*65536.)))/65536.;
    push(top);
    int videoout = int(pop()*65536.);
*/    

    // videoout -> yuv -> rgb conversion
    int cy = mod_op(log_rshift(videoout,8), 256);
    int cu = xor_op(mod_op(log_rshift(videoout, 16), 256), 128)-128;
    int cv = xor_op(log_rshift(videoout, 24), 128)-128;

    gl_FragColor = vec4(
        float(298*cy + 409*cv + 128)/65536.,
        float(298*cy - 100*cu - 208*cv +128)/65536.,
        float(298*cy + 516*cu + 128)/65536.,
        1.);
}
	 