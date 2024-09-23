let today = new Date();
let timer;

const calendar = Widget.Calendar({
    showDayNames: true,
    showDetails: false,
    showHeading: true,
    showWeekNumbers: false,
    margin: 3,
    onDaySelected: ({ date: [y, m, d] }) => {
        today = new Date();
        const currentYear = today.getFullYear();
        const currentMonth = today.getMonth();
        const currentDate = today.getDate();

        if (timer) {
            clearTimeout(timer);
        }

        if (calendar.day != currentDate || calendar.month != currentMonth || calendar.year != currentYear) {
            print(`Selected date changed on ${d}.${m + 1}.${y}.`)
            
            timer = setTimeout(() => {
                calendar.day = currentDate;
                calendar.month = currentMonth;
                calendar.year = currentYear;
                print(`Date reset to today's date: ${currentDate}.${currentMonth + 1}.${currentYear}.`);
            }, 60000);
        }
    },
})

function formatDate() {
    today = new Date()
    const currentYear = today.getFullYear();
    const currentMonth = today.getMonth();
    const currentDate = today.getDate();
    
    const months = [
        "Января", "Февраля", "Марта", "Апреля", "Мая", "Июня",
        "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря"
//     ------------------------ EN ------------------------
//        "January", "February", "March", "April", "May", "June",
//        "July", "August", "September", "October", "November", "December"
    ];
    
    const month = months[currentMonth];

    return `${currentDate} ${month} ${currentYear}`; // Format as "D Month YYYY"
}

const label = Widget.Label({
    label: formatDate(),
})

function updateCalendarDate() {
    today = new Date();
    const currentYear = today.getFullYear();
    const currentMonth = today.getMonth();
    const currentDate = today.getDate();

    if (calendar.day != currentDate || calendar.month != currentMonth || calendar.year != currentYear) {
        calendar.day = currentDate;
        calendar.month = currentMonth;
        calendar.year = currentYear;
        print(`Updated to today's date: ${currentDate}.${currentMonth + 1}.${currentYear}.`);
        label.label = formatDate();
    }
}

setInterval(updateCalendarDate, 60000);

App.config({
    style: './style.css',
})

const subbox = Widget.Box({
    name: 'subbox',
    margin: 200,
    children: [
        calendar
    ]
})

const centerBox = Widget.CenterBox({
    spacing: 30,
    vertical: true,
    startWidget: label,
    centerWidget: Widget.Label(""),
    endWidget: subbox,
})

const window = Widget.Window({
    name: 'main',
    anchor: ['top', 'bottom'],
    exclusivity: 'ignore',
    keymode: 'on-demand',
    layer: 'background',
    monitor: 0,
    child: centerBox,
})