// By @eddbiddulph
//
// This is the backdrop to the opening scene from the cult classic computer game Another World.
// This image was originally designed and implemented by Eric Chahi. I recreated it by
// modifying the reverse-engineered Another World source code available at
// http://fabiensanglard.net/anotherWorld_code_review/index.php.
// In the process I ran up against constant data storage limitation, instruction
// count limitation, and graphics driver reset convulsions. 
//
// Note that (much to my annoyance) not every element of the backdrop is present. This is because
// either my driver or glslsandbox will not accept a shader much bigger than this one.
//
// Chahi's rasterization algorithm is simple to understand once you realize that it
// is NOT a generalized polygon renderer...
//
// Please visit http://www.anotherworld.fr/anotherworld_uk/index.htm

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// return 1.0 when e0 < x < e1, otherwise return 0.0
float box(float e0, float e1, float x)
{
    return step(e0, x) - step(e1, x);
}

// return 1.0 when p is within a given trapezium, otherwise return 0.0
float section(  float y0, float y1, float dxdy0, float dxdy1,
                float x0_ofs, float x1_ofs, vec2 p)
{
    float x0 = dxdy0 * p.y + x0_ofs, x1 = dxdy1 * p.y + x1_ofs;
    return box(y0, y1, p.y) * box(x0, x1, p.x);
}

void main()
{
    vec3 palette[16];
    
    palette[0] = vec3(0.063, 0.063, 0.063);
    palette[1] = vec3(0.540, 0.000, 0.000);
    palette[2] = vec3(0.063, 0.127, 0.270);
    palette[3] = vec3(0.063, 0.190, 0.333);
    palette[4] = vec3(0.127, 0.270, 0.397);
    palette[5] = vec3(0.190, 0.333, 0.460);
    palette[6] = vec3(0.333, 0.460, 0.603);
    palette[7] = vec3(0.460, 0.667, 0.730);
    palette[8] = vec3(0.730, 0.540, 0.000);
    palette[9] = vec3(1.000, 0.000, 0.000);
    palette[10] = vec3(0.810, 0.603, 0.000);
    palette[11] = vec3(0.873, 0.667, 0.000);
    palette[12] = vec3(0.937, 0.810, 0.000);
    palette[13] = vec3(1.000, 0.937, 0.000);
    palette[14] = vec3(1.000, 1.000, 0.460);
    palette[15] = vec3(1.000, 1.000, 0.667);

    vec2 tex_resolution = vec2(320.0, 200.0);
    vec2 position = gl_FragCoord.xy * tex_resolution / resolution;
    position.y = tex_resolution.y - position.y; // flip image

    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    gl_FragColor.rgb = palette[2]; // hacked-in background colour

    // polygon 5
    // numPoints = 4
    float mask = section(-2.000000, 121.000000, 0.000000, 0.000000, 65.000000, 320.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 7
    // numPoints = 4
    mask = section(-11.000000, 112.000000, 0.000000, 0.000000, -82.000000, 173.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 9
    // numPoints = 4
    mask = section(78.000000, 135.000000, -0.017544, 0.017544, 305.368421, 302.631579, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 11
    // numPoints = 6
    mask = section(94.000000, 100.000000, -0.666667, -0.666667, 362.666667, 362.666667, position);
    mask = max(mask, section(100.000000, 103.000000, 0.666667, 2.666667, 229.333333, 29.333333, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 14
    // numPoints = 8
    mask = section(103.000000, 108.000000, 1.200000, 1.400000, 161.400000, 140.800000, position);
    mask = max(mask, section(108.000000, 110.000000, -0.500000, 0.000000, 345.000000, 292.000000, position));
    mask = max(mask, section(110.000000, 112.000000, 2.000000, 5.000000, 70.000000, -258.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 18
    // numPoints = 8
    mask = section(84.000000, 90.000000, -0.166667, 0.000000, 299.000000, 285.000000, position);
    mask = max(mask, section(90.000000, 94.000000, -2.750000, -2.500000, 531.500000, 510.000000, position));
    mask = max(mask, section(94.000000, 97.000000, 2.666667, 3.666667, 22.333333, -69.666667, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 22
    // numPoints = 4
    mask = section(86.000000, 113.000000, -2.111111, -2.185185, 513.555556, 523.925926, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 24
    // numPoints = 4
    mask = section(72.000000, 126.000000, -0.685185, -0.500000, 351.333333, 341.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 26
    // numPoints = 4
    mask = section(76.000000, 131.000000, -0.672727, -0.727273, 388.127273, 395.272727, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 28
    // numPoints = 4
    mask = section(72.000000, 132.000000, 0.800000, 0.766667, 195.400000, 199.800000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 30
    // numPoints = 4
    mask = section(36.000000, 39.000000, 6.000000, -22.666667, -4.000000, 1116.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 32
    // numPoints = 8
    mask = section(203.000000, 209.000000, -11.166667, 14.000000, 2422.833333, -2668.000000, position);
    mask = max(mask, section(209.000000, 210.000000, 19.000000, -88.000000, -3882.000000, 18650.000000, position));
    mask = max(mask, section(210.000000, 214.000000, -26.250000, 13.500000, 5620.500000, -2665.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 32
    // numPoints = 8
    mask = section(-3.000000, 3.000000, -11.166667, 14.000000, 207.500000, 301.000000, position);
    mask = max(mask, section(3.000000, 4.000000, 19.000000, -88.000000, 117.000000, 607.000000, position));
    mask = max(mask, section(4.000000, 8.000000, -26.250000, 13.500000, 298.000000, 201.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 36
    // numPoints = 8
    mask = section(12.000000, 18.000000, -11.166667, 14.000000, 408.000000, 124.000000, position);
    mask = max(mask, section(18.000000, 19.000000, 19.000000, -88.000000, -135.000000, 1960.000000, position));
    mask = max(mask, section(19.000000, 23.000000, -26.250000, 13.500000, 724.750000, 31.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 40
    // numPoints = 8
    mask = section(4.000000, 10.000000, -11.166667, 14.000000, 117.666667, 35.000000, position);
    mask = max(mask, section(10.000000, 11.000000, 19.000000, -88.000000, -184.000000, 1055.000000, position));
    mask = max(mask, section(11.000000, 15.000000, -26.250000, 13.500000, 313.750000, -61.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 44
    // numPoints = 8
    mask = section(42.000000, 48.000000, -11.166667, 14.000000, 733.000000, -306.000000, position);
    mask = max(mask, section(48.000000, 49.000000, 19.000000, -88.000000, -715.000000, 4590.000000, position));
    mask = max(mask, section(49.000000, 53.000000, -26.250000, 13.500000, 1502.250000, -383.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 48
    // numPoints = 8
    mask = section(-3.000000, 1.000000, -21.000000, 19.250000, 165.000000, 295.750000, position);
    mask = max(mask, section(1.000000, 3.000000, 35.000000, 35.500000, 109.000000, 279.500000, position));
    mask = max(mask, section(3.000000, 4.000000, 25.000000, -136.000000, 139.000000, 794.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 52
    // numPoints = 8
    mask = section(9.000000, 13.000000, -21.000000, 19.250000, 365.000000, 12.750000, position);
    mask = max(mask, section(13.000000, 15.000000, 35.000000, 35.500000, -363.000000, -198.500000, position));
    mask = max(mask, section(15.000000, 16.000000, 25.000000, -136.000000, -213.000000, 2374.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 56
    // numPoints = 8
    mask = section(2.000000, 6.000000, -21.000000, 19.250000, 103.000000, 32.500000, position);
    mask = max(mask, section(6.000000, 8.000000, 35.000000, 35.500000, -233.000000, -65.000000, position));
    mask = max(mask, section(8.000000, 9.000000, 25.000000, -136.000000, -153.000000, 1307.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 60
    // numPoints = 6
    mask = section(27.000000, 28.000000, -50.000000, 30.000000, 1386.000000, -743.000000, position);
    mask = max(mask, section(28.000000, 30.000000, 19.500000, 22.500000, -560.000000, -533.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 63
    // numPoints = 6
    mask = section(0.000000, 1.000000, -50.000000, 30.000000, 15.000000, 46.000000, position);
    mask = max(mask, section(1.000000, 3.000000, 19.500000, 22.500000, -54.500000, 53.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[6], mask);
    // polygon 66
    // numPoints = 4
    mask = section(32.000000, 33.000000, -1.000000, 0.000000, 296.000000, 334.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 68
    // numPoints = 6
    mask = section(0.000000, 1.000000, -50.000000, 30.000000, 123.000000, 154.000000, position);
    mask = max(mask, section(1.000000, 3.000000, 19.500000, 22.500000, 53.500000, 161.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[6], mask);
    // polygon 71
    // numPoints = 6
    mask = section(-3.000000, 1.000000, -22.000000, 29.000000, 43.000000, 233.000000, position);
    mask = max(mask, section(1.000000, 3.000000, 61.000000, -57.000000, -40.000000, 319.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 74
    // numPoints = 4
    mask = section(47.000000, 50.000000, 6.000000, -22.666667, -34.000000, 1401.333333, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 76
    // numPoints = 4
    mask = section(21.000000, 24.000000, 6.000000, -22.666667, -127.000000, 563.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 78
    // numPoints = 4
    mask = section(15.000000, 16.000000, -1.000000, 0.000000, 194.000000, 249.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[6], mask);
    // polygon 80
    // numPoints = 4
    mask = section(66.000000, 67.000000, -12.000000, -17.000000, 1028.000000, 1462.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 82
    // numPoints = 4
    mask = section(86.000000, 87.000000, -12.000000, -17.000000, 1266.000000, 1800.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 84
    // numPoints = 4
    mask = section(96.000000, 97.000000, -12.000000, -17.000000, 1388.000000, 1972.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 86
    // numPoints = 4
    mask = section(76.000000, 77.000000, -12.000000, -17.000000, 1147.000000, 1631.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 88
    // numPoints = 4
    mask = section(63.000000, 120.000000, -0.017544, 0.017544, 306.105263, 303.894737, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 90
    // numPoints = 4
    mask = section(81.000000, 82.000000, -12.000000, -17.000000, 1208.000000, 1717.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 92
    // numPoints = 4
    mask = section(71.000000, 72.000000, -12.000000, -17.000000, 1087.000000, 1546.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 94
    // numPoints = 4
    mask = section(91.000000, 92.000000, -12.000000, -17.000000, 1326.000000, 1885.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 96
    // numPoints = 4
    mask = section(101.000000, 102.000000, -12.000000, -17.000000, 1446.000000, 2055.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 98
    // numPoints = 4
    mask = section(59.000000, 116.000000, -0.017544, 0.017544, 272.035088, 269.964912, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 100
    // numPoints = 4
    mask = section(60.000000, 117.000000, -0.017544, 0.017544, 263.052632, 260.947368, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 102
    // numPoints = 4
    mask = section(62.000000, 119.000000, -0.017544, 0.017544, 301.087719, 298.912281, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 104
    // numPoints = 4
    mask = section(60.000000, 117.000000, -0.017544, 0.017544, 276.052632, 273.947368, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 106
    // numPoints = 4
    mask = section(62.000000, 119.000000, -0.017544, 0.017544, 249.087719, 246.912281, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 108
    // numPoints = 4
    mask = section(60.000000, 117.000000, -0.017544, 0.017544, 311.052632, 308.947368, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 110
    // numPoints = 4
    mask = section(60.000000, 117.000000, -0.017544, 0.017544, 238.052632, 235.947368, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 112
    // numPoints = 4
    mask = section(65.000000, 122.000000, -0.017544, 0.017544, 243.140351, 240.859649, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 114
    // numPoints = 4
    mask = section(59.000000, 116.000000, -0.017544, 0.017544, 321.035088, 318.964912, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 116
    // numPoints = 4
    mask = section(116.000000, 117.000000, -12.000000, -17.000000, 1626.000000, 2310.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 118
    // numPoints = 4
    mask = section(111.000000, 112.000000, -12.000000, -17.000000, 1568.000000, 2227.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 120
    // numPoints = 4
    mask = section(60.000000, 117.000000, -0.017544, 0.017544, 286.052632, 283.947368, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 122
    // numPoints = 4
    mask = section(63.000000, 120.000000, -0.017544, 0.017544, 254.105263, 251.894737, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 124
    // numPoints = 4
    mask = section(106.000000, 107.000000, -12.000000, -17.000000, 1511.000000, 2145.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 126
    // numPoints = 4
    mask = section(63.000000, 120.000000, -0.017544, 0.017544, 259.105263, 256.894737, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 128
    // numPoints = 4
    mask = section(60.000000, 117.000000, -0.017544, 0.017544, 291.052632, 288.947368, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 130
    // numPoints = 4
    mask = section(63.000000, 120.000000, -0.017544, 0.017544, 316.105263, 313.894737, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 132
    // numPoints = 4
    mask = section(60.000000, 117.000000, -0.017544, 0.017544, 281.052632, 278.947368, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 134
    // numPoints = 4
    mask = section(63.000000, 120.000000, -0.017544, 0.017544, 233.105263, 230.894737, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 136
    // numPoints = 4
    mask = section(63.000000, 120.000000, -0.017544, 0.017544, 268.105263, 265.894737, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 138
    // numPoints = 4
    mask = section(63.000000, 120.000000, -0.017544, 0.017544, 296.105263, 293.894737, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 140
    // numPoints = 4
    mask = section(63.000000, 120.000000, -0.017544, 0.017544, 326.105263, 323.894737, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 140
    // numPoints = 4
    mask = section(39.000000, 120.000000, -0.111111, -0.037037, 275.333333, 276.444444, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 142
    // numPoints = 4
    mask = section(61.000000, 121.000000, 0.800000, 0.766667, 224.200000, 228.233333, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 144
    // numPoints = 4
    mask = section(71.000000, 126.000000, -0.672727, -0.727273, 315.763636, 322.636364, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 146
    // numPoints = 4
    mask = section(69.000000, 123.000000, -0.685185, -0.500000, 373.277778, 363.500000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 148
    // numPoints = 4
    mask = section(88.000000, 115.000000, -2.111111, -2.185185, 496.777778, 507.296296, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 150
    // numPoints = 6
    mask = section(116.000000, 122.000000, -0.666667, -0.666667, 393.333333, 393.333333, position);
    mask = max(mask, section(122.000000, 125.000000, 0.666667, 2.666667, 230.666667, -13.333333, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 153
    // numPoints = 6
    mask = section(115.000000, 121.000000, -0.666667, -0.666667, 386.666667, 386.666667, position);
    mask = max(mask, section(121.000000, 124.000000, 0.666667, 2.666667, 225.333333, -16.666667, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 156
    // numPoints = 8
    mask = section(115.000000, 120.000000, 1.200000, 1.400000, 150.000000, 127.000000, position);
    mask = max(mask, section(120.000000, 122.000000, -0.500000, 0.000000, 354.000000, 295.000000, position));
    mask = max(mask, section(122.000000, 124.000000, 2.000000, 5.000000, 49.000000, -315.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 160
    // numPoints = 8
    mask = section(112.000000, 118.000000, -0.166667, 0.000000, 325.666667, 307.000000, position);
    mask = max(mask, section(118.000000, 122.000000, -2.750000, -2.500000, 630.500000, 602.000000, position));
    mask = max(mask, section(122.000000, 125.000000, 2.666667, 3.666667, -30.333333, -150.333333, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 164
    // numPoints = 8
    mask = section(112.000000, 118.000000, -0.166667, 0.000000, 319.666667, 301.000000, position);
    mask = max(mask, section(118.000000, 122.000000, -2.750000, -2.500000, 624.500000, 596.000000, position));
    mask = max(mask, section(122.000000, 125.000000, 2.666667, 3.666667, -36.333333, -156.333333, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 168
    // numPoints = 8
    mask = section(113.000000, 119.000000, -0.166667, 0.000000, 336.833333, 318.000000, position);
    mask = max(mask, section(119.000000, 123.000000, -2.750000, -2.500000, 644.250000, 615.500000, position));
    mask = max(mask, section(123.000000, 126.000000, 2.666667, 3.666667, -22.000000, -143.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 172
    // numPoints = 8
    mask = section(116.000000, 121.000000, 1.200000, 1.400000, 158.800000, 135.600000, position);
    mask = max(mask, section(121.000000, 123.000000, -0.500000, 0.000000, 364.500000, 305.000000, position));
    mask = max(mask, section(123.000000, 125.000000, 2.000000, 5.000000, 57.000000, -310.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 176
    // numPoints = 8
    mask = section(116.000000, 121.000000, 1.200000, 1.400000, 175.800000, 152.600000, position);
    mask = max(mask, section(121.000000, 123.000000, -0.500000, 0.000000, 381.500000, 322.000000, position));
    mask = max(mask, section(123.000000, 125.000000, 2.000000, 5.000000, 74.000000, -293.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 180
    // numPoints = 8
    mask = section(117.000000, 122.000000, 1.200000, 1.400000, 172.600000, 149.200000, position);
    mask = max(mask, section(122.000000, 124.000000, -0.500000, 0.000000, 380.000000, 320.000000, position));
    mask = max(mask, section(124.000000, 126.000000, 2.000000, 5.000000, 70.000000, -300.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 184
    // numPoints = 6
    mask = section(116.000000, 122.000000, -0.666667, -0.666667, 368.333333, 368.333333, position);
    mask = max(mask, section(122.000000, 125.000000, 0.666667, 2.666667, 205.666667, -38.333333, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 187
    // numPoints = 6
    mask = section(117.000000, 123.000000, -0.666667, -0.666667, 407.000000, 407.000000, position);
    mask = max(mask, section(123.000000, 126.000000, 0.666667, 2.666667, 243.000000, -3.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 187
    // numPoints = 6
    mask = section(116.000000, 122.000000, -0.666667, -0.666667, 365.333333, 365.333333, position);
    mask = max(mask, section(122.000000, 125.000000, 0.666667, 2.666667, 202.666667, -41.333333, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 190
    // numPoints = 4
    mask = section(143.000000, 144.000000, -1.000000, 0.000000, 299.000000, 226.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 192
    // numPoints = 4
    mask = section(31.000000, 126.000000, 0.000000, 0.000000, -1.000000, 39.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 194
    // numPoints = 8
    mask = section(31.000000, 50.000000, 0.000000, 0.631579, 33.000000, 185.421053, position);
    mask = max(mask, section(50.000000, 77.000000, 0.000000, 0.777778, 33.000000, 178.111111, position));
    mask = max(mask, section(77.000000, 126.000000, 0.000000, 1.020408, 33.000000, 159.428571, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[4], mask);
    // polygon 198
    // numPoints = 4
    mask = section(71.000000, 126.000000, 0.000000, 0.000000, 185.000000, 204.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[6], mask);
    // polygon 200
    // numPoints = 4
    mask = section(125.000000, 126.000000, 0.000000, 0.000000, 185.000000, 204.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 202
    // numPoints = 4
    mask = section(71.000000, 126.000000, 0.000000, 0.000000, 185.000000, 185.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 204
    // numPoints = 4
    mask = section(72.000000, 73.000000, 0.000000, 0.000000, 185.000000, 204.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 206
    // numPoints = 4
    mask = section(71.000000, 126.000000, 0.000000, 0.000000, 204.000000, 204.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 208
    // numPoints = 4
    mask = section(99.000000, 100.000000, 0.000000, 0.000000, 200.000000, 201.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 210
    // numPoints = 4
    mask = section(99.000000, 100.000000, 0.000000, 0.000000, 198.000000, 199.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 212
    // numPoints = 4
    mask = section(100.000000, 101.000000, 0.000000, 0.000000, 200.000000, 201.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 214
    // numPoints = 4
    mask = section(99.000000, 100.000000, 0.000000, 0.000000, 199.000000, 200.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 216
    // numPoints = 4
    mask = section(71.000000, 72.000000, 0.000000, 0.000000, 185.000000, 204.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 218
    // numPoints = 4
    mask = section(83.000000, 84.000000, 0.000000, 0.000000, 196.000000, 197.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 220
    // numPoints = 4
    mask = section(71.000000, 126.000000, 0.000000, 0.000000, 50.000000, 69.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[6], mask);
    // polygon 222
    // numPoints = 4
    mask = section(125.000000, 126.000000, 0.000000, 0.000000, 50.000000, 69.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 224
    // numPoints = 4
    mask = section(71.000000, 126.000000, 0.000000, 0.000000, 50.000000, 50.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 226
    // numPoints = 4
    mask = section(72.000000, 73.000000, 0.000000, 0.000000, 50.000000, 69.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 228
    // numPoints = 4
    mask = section(71.000000, 126.000000, 0.000000, 0.000000, 69.000000, 69.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 230
    // numPoints = 4
    mask = section(99.000000, 100.000000, 0.000000, 0.000000, 65.000000, 66.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 232
    // numPoints = 4
    mask = section(99.000000, 100.000000, 0.000000, 0.000000, 63.000000, 64.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 234
    // numPoints = 4
    mask = section(100.000000, 101.000000, 0.000000, 0.000000, 65.000000, 66.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 236
    // numPoints = 4
    mask = section(99.000000, 100.000000, 0.000000, 0.000000, 64.000000, 65.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 238
    // numPoints = 4
    mask = section(71.000000, 72.000000, 0.000000, 0.000000, 50.000000, 69.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 240
    // numPoints = 4
    mask = section(83.000000, 84.000000, 0.000000, 0.000000, 61.000000, 62.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 242
    // numPoints = 4
    mask = section(78.000000, 95.000000, 0.000000, 0.000000, 133.000000, 152.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 244
    // numPoints = 4
    mask = section(77.000000, 94.000000, 0.000000, 0.000000, 136.000000, 149.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 246
    // numPoints = 4
    mask = section(95.000000, 98.000000, 1.666667, -1.333333, -25.333333, 271.666667, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 248
    // numPoints = 4
    mask = section(78.000000, 95.000000, 0.000000, 0.000000, 132.000000, 133.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 250
    // numPoints = 4
    mask = section(94.000000, 95.000000, 0.000000, 0.000000, 133.000000, 152.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 252
    // numPoints = 4
    mask = section(78.000000, 79.000000, 0.000000, 0.000000, 132.000000, 133.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[6], mask);
    // polygon 254
    // numPoints = 4
    mask = section(94.000000, 95.000000, 0.000000, 0.000000, 143.000000, 144.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 256
    // numPoints = 4
    mask = section(77.000000, 78.000000, 0.000000, 0.000000, 133.000000, 152.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 258
    // numPoints = 4
    mask = section(94.000000, 95.000000, 0.000000, 0.000000, 133.000000, 134.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[6], mask);
    // polygon 260
    // numPoints = 8
    mask = section(31.000000, 51.000000, 0.350000, 0.600000, 191.150000, 186.400000, position);
    mask = max(mask, section(51.000000, 82.000000, 0.677419, 0.774194, 174.451613, 177.516129, position));
    mask = max(mask, section(82.000000, 126.000000, 0.454545, 1.045455, 192.727273, 155.272727, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 264
    // numPoints = 8
    mask = section(31.000000, 51.000000, 0.450000, 0.600000, 190.050000, 185.400000, position);
    mask = max(mask, section(51.000000, 82.000000, 0.677419, 0.774194, 178.451613, 176.516129, position));
    mask = max(mask, section(82.000000, 126.000000, 0.818182, 1.068182, 166.909091, 152.409091, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[6], mask);
    // polygon 268
    // numPoints = 8
    mask = section(32.000000, 51.000000, 0.526316, 0.526316, 188.157895, 188.157895, position);
    mask = max(mask, section(51.000000, 82.000000, 0.709677, 0.806452, 178.806452, 173.870968, position));
    mask = max(mask, section(82.000000, 125.000000, 0.883721, 1.046512, 164.534884, 154.186047, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[7], mask);
    // polygon 272
    // numPoints = 4
    mask = section(31.000000, 34.000000, 6.000000, -22.666667, -201.000000, 775.666667, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 274
    // numPoints = 6
    mask = section(31.000000, 33.000000, -1.000000, -4.000000, 225.000000, 326.000000, position);
    mask = max(mask, section(33.000000, 56.000000, -0.217391, -0.304348, 199.173913, 204.043478, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 277
    // numPoints = 6
    mask = section(115.000000, 123.000000, 0.000000, 0.250000, 70.000000, 41.250000, position);
    mask = max(mask, section(123.000000, 126.000000, 0.000000, 2.666667, 70.000000, -256.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 280
    // numPoints = 6
    mask = section(120.000000, 122.000000, 0.000000, 0.000000, 89.000000, 89.000000, position);
    mask = max(mask, section(122.000000, 126.000000, -0.750000, 0.750000, 180.500000, -2.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 283
    // numPoints = 6
    mask = section(120.000000, 122.000000, 0.000000, 0.000000, 105.000000, 105.000000, position);
    mask = max(mask, section(122.000000, 126.000000, -0.750000, 0.750000, 196.500000, 13.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 286
    // numPoints = 6
    mask = section(120.000000, 122.000000, 0.000000, 0.000000, 180.000000, 180.000000, position);
    mask = max(mask, section(122.000000, 126.000000, -0.750000, 0.750000, 271.500000, 88.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 289
    // numPoints = 6
    mask = section(120.000000, 122.000000, 0.000000, 0.000000, 181.000000, 181.000000, position);
    mask = max(mask, section(122.000000, 126.000000, -0.750000, 0.750000, 272.500000, 89.500000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 292
    // numPoints = 6
    mask = section(115.000000, 123.000000, 0.000000, 0.250000, 205.000000, 176.250000, position);
    mask = max(mask, section(123.000000, 126.000000, 0.000000, 2.666667, 205.000000, -121.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 295
    // numPoints = 4
    mask = section(114.000000, 115.000000, 0.000000, 0.000000, 35.000000, 36.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 297
    // numPoints = 4
    mask = section(104.000000, 105.000000, 0.000000, 0.000000, 29.000000, 30.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 299
    // numPoints = 4
    mask = section(118.000000, 119.000000, 0.000000, 0.000000, 6.000000, 25.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 301
    // numPoints = 4
    mask = section(119.000000, 120.000000, 0.000000, 0.000000, 6.000000, 25.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 303
    // numPoints = 4
    mask = section(118.000000, 119.000000, 0.000000, 0.000000, 3.000000, 4.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 305
    // numPoints = 4
    mask = section(118.000000, 119.000000, 0.000000, 0.000000, -2.000000, -1.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 305
    // numPoints = 4
    mask = section(113.000000, 114.000000, 0.000000, 0.000000, 101.000000, 120.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 307
    // numPoints = 4
    mask = section(114.000000, 115.000000, 0.000000, 0.000000, 101.000000, 120.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 309
    // numPoints = 4
    mask = section(113.000000, 114.000000, 0.000000, 0.000000, 98.000000, 99.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 311
    // numPoints = 4
    mask = section(113.000000, 114.000000, 0.000000, 0.000000, 93.000000, 94.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 313
    // numPoints = 4
    mask = section(123.000000, 124.000000, 0.000000, 0.000000, 24.000000, 43.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[2], mask);
    // polygon 315
    // numPoints = 4
    mask = section(124.000000, 125.000000, 0.000000, 0.000000, 24.000000, 43.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 317
    // numPoints = 4
    mask = section(123.000000, 124.000000, 0.000000, 0.000000, 21.000000, 22.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 319
    // numPoints = 4
    mask = section(123.000000, 124.000000, 0.000000, 0.000000, 16.000000, 17.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 321
    // numPoints = 4
    mask = section(59.000000, 60.000000, 0.000000, 0.000000, 110.000000, 111.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 323
    // numPoints = 4
    mask = section(60.000000, 61.000000, 0.000000, 0.000000, 115.000000, 116.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 325
    // numPoints = 4
    mask = section(121.000000, 122.000000, 0.000000, 0.000000, 76.000000, 77.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 327
    // numPoints = 4
    mask = section(122.000000, 123.000000, 0.000000, 0.000000, 81.000000, 82.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 329
    // numPoints = 4
    mask = section(117.000000, 118.000000, 0.000000, 0.000000, 125.000000, 126.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 331
    // numPoints = 4
    mask = section(107.000000, 108.000000, 0.000000, 0.000000, 119.000000, 120.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 333
    // numPoints = 4
    mask = section(117.000000, 118.000000, 0.000000, 0.000000, 15.000000, 16.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 335
    // numPoints = 4
    mask = section(118.000000, 119.000000, 0.000000, 0.000000, 20.000000, 21.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 337
    // numPoints = 4
    mask = section(55.000000, 56.000000, 0.000000, 0.000000, 153.000000, 154.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 339
    // numPoints = 4
    mask = section(45.000000, 46.000000, 0.000000, 0.000000, 147.000000, 148.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 341
    // numPoints = 4
    mask = section(113.000000, 114.000000, 0.000000, 0.000000, -8.000000, -7.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 341
    // numPoints = 4
    mask = section(114.000000, 115.000000, 0.000000, 0.000000, -3.000000, -2.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 341
    // numPoints = 4
    mask = section(125.000000, 126.000000, -1.000000, 0.000000, 233.000000, 178.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 343
    // numPoints = 4
    mask = section(126.000000, 127.000000, -1.000000, 0.000000, 103.000000, 47.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 345
    // numPoints = 8
    mask = section(127.000000, 130.000000, 1.000000, -50.333333, -143.000000, 6625.333333, position);
    mask = max(mask, section(130.000000, 137.000000, -0.285714, -7.857143, 24.142857, 1103.428571, position));
    mask = max(mask, section(137.000000, 149.000000, 0.000000, -3.333333, -15.000000, 483.666667, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 349
    // numPoints = 4
    mask = section(171.000000, 175.000000, -8.250000, 4.000000, 1639.750000, -433.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 351
    // numPoints = 4
    mask = section(178.000000, 179.000000, 0.000000, 0.000000, 241.000000, 242.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 353
    // numPoints = 4
    mask = section(175.000000, 176.000000, 0.000000, 0.000000, 206.000000, 207.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 355
    // numPoints = 4
    mask = section(175.000000, 176.000000, 0.000000, 0.000000, 209.000000, 210.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 357
    // numPoints = 4
    mask = section(174.000000, 175.000000, 0.000000, 0.000000, 198.000000, 199.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 359
    // numPoints = 4
    mask = section(174.000000, 175.000000, 0.000000, 0.000000, 273.000000, 274.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 361
    // numPoints = 4
    mask = section(175.000000, 176.000000, 0.000000, 0.000000, 220.000000, 221.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 363
    // numPoints = 4
    mask = section(173.000000, 174.000000, 0.000000, 0.000000, 192.000000, 193.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 365
    // numPoints = 4
    mask = section(176.000000, 177.000000, 0.000000, 0.000000, 232.000000, 233.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[0], mask);
    // polygon 367
    // numPoints = 4
    mask = section(174.000000, 175.000000, 0.000000, 0.000000, 277.000000, 278.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 369
    // numPoints = 4
    mask = section(175.000000, 176.000000, 0.000000, 0.000000, 252.000000, 253.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 371
    // numPoints = 4
    mask = section(174.000000, 175.000000, 0.000000, 0.000000, 268.000000, 269.000000, position);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 373
    // numPoints = 8
    mask = section(51.000000, 60.000000, -0.333333, -0.222222, 107.000000, 102.333333, position);
    mask = max(mask, section(60.000000, 72.000000, 0.000000, 0.166667, 87.000000, 79.000000, position));
    mask = max(mask, section(72.000000, 73.000000, 1.000000, 5.000000, 15.000000, -269.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);
    // polygon 377
    // numPoints = 8
    mask = section(51.000000, 53.000000, 1.500000, -0.500000, 15.500000, 122.500000, position);
    mask = max(mask, section(53.000000, 59.000000, -0.166667, -0.166667, 103.833333, 104.833333, position));
    mask = max(mask, section(59.000000, 73.000000, 0.000000, 0.000000, 94.000000, 95.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[3], mask);
    // polygon 381
    // numPoints = 8
    mask = section(31.000000, 40.000000, -0.666667, -0.444444, 171.666667, 164.777778, position);
    mask = max(mask, section(40.000000, 52.000000, 0.000000, 0.166667, 145.000000, 140.333333, position));
    mask = max(mask, section(52.000000, 53.000000, 1.000000, 5.000000, 93.000000, -111.000000, position));
    gl_FragColor.rgb = mix(gl_FragColor.rgb, palette[5], mask);


}
