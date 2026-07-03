let revealedCount = 0;
let totalSquares = 0;
let isScratching = false;

window.addEventListener("message", (event) => {
    const { action, data } = event.data;

    if (action === "setVisible") {
        if (data) {
            document.body.classList.remove("pointer-events-none");
            document.body.classList.add("opacity-100");
        } else {
            document.body.classList.add("pointer-events-none");
            document.body.classList.remove("opacity-100");
        }
    }

    if (action === "prizeData") {
        setupGrid(data);
    }
});

const setupGrid = (prizes) => {
    const grid = document.getElementById("scratch-grid");
    grid.innerHTML = "";
    revealedCount = 0;
    totalSquares = prizes.length;

    prizes.forEach((prize, index) => {
        const box = document.createElement("div");
        box.className = "scratch-box";
        
        const content = document.createElement("div");
        content.className = "scratch-content";
        content.innerHTML = `
            <div class="text-[#005596] text-xl mb-1">
                <i class="fa-solid fa-${prize.icon}"></i>
            </div>
            <div class="font-black text-[#005596] text-sm">${prize.amount}</div>
            <div class="text-[8px] font-bold text-[#005596]/50">KRONOR</div>
        `;
        
        const canvas = document.createElement("canvas");
        box.appendChild(content);
        box.appendChild(canvas);
        grid.appendChild(box);

        initScratch(canvas, box);
    });
};

const initScratch = (canvas, parent) => {
    const ctx = canvas.getContext("2d");
    const rect = parent.getBoundingClientRect();
    canvas.width = rect.width;
    canvas.height = rect.height;

    // Fyll canvas med "skrap-ytskydd" (Svenska Spel blå/guld mönster)
    ctx.fillStyle = "#005596";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    
    // Lägg till lite "glans" eller mönster
    ctx.strokeStyle = "#ffcc0033";
    ctx.lineWidth = 2;
    for(let i=0; i<canvas.width; i+=10) {
        ctx.beginPath();
        ctx.moveTo(i, 0);
        ctx.lineTo(i + 20, canvas.height);
        ctx.stroke();
    }

    // Text på skrapytan
    ctx.fillStyle = "white";
    ctx.font = "bold 12px Arial";
    ctx.textAlign = "center";
    ctx.fillText("SKRAPA HÄR", canvas.width / 2, canvas.height / 2 + 5);

    let isDrawing = false;

    const scratch = (x, y) => {
        ctx.globalCompositeOperation = "destination-out";
        ctx.beginPath();
        ctx.arc(x, y, 15, 0, Math.PI * 2);
        ctx.fill();
        checkReveal(canvas, parent);
    };

    canvas.addEventListener("mousedown", (e) => {
        isDrawing = true;
        scratch(e.offsetX, e.offsetY);
    });

    canvas.addEventListener("mousemove", (e) => {
        if (isDrawing) scratch(e.offsetX, e.offsetY);
    });

    window.addEventListener("mouseup", () => {
        isDrawing = false;
    });

    // Touch support
    canvas.addEventListener("touchstart", (e) => {
        isDrawing = true;
        const touch = e.touches[0];
        const b = canvas.getBoundingClientRect();
        scratch(touch.clientX - b.left, touch.clientY - b.top);
    });

    canvas.addEventListener("touchmove", (e) => {
        if (!isDrawing) return;
        const touch = e.touches[0];
        const b = canvas.getBoundingClientRect();
        scratch(touch.clientX - b.left, touch.clientY - b.top);
        e.preventDefault();
    });
};

const checkReveal = (canvas, parent) => {
    if (parent.classList.contains("revealed")) return;

    const ctx = canvas.getContext("2d");
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const pixels = imageData.data;
    let transparent = 0;

    for (let i = 0; i < pixels.length; i += 4) {
        if (pixels[i + 3] < 128) transparent++;
    }

    const percent = (transparent / (pixels.length / 4)) * 100;
    if (percent > 50) {
        parent.classList.add("revealed");
        canvas.style.transition = "opacity 0.5s";
        canvas.style.opacity = "0";
        setTimeout(() => canvas.remove(), 500);
        
        revealedCount++;
        if (revealedCount === totalSquares) {
            setTimeout(completeGame, 1000);
        }
    }
};

const completeGame = () => {
    fetch(`https://${GetParentResourceName()}/scratcherComplete`, {
        method: "POST",
        body: JSON.stringify({}),
    });
};

document.getElementById("close-btn").addEventListener("click", () => {
    fetch(`https://${GetParentResourceName()}/hideFrame`, {
        method: "POST",
        body: JSON.stringify({}),
    });
});

document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/hideFrame`, {
            method: "POST",
            body: JSON.stringify({}),
        });
    }
});
