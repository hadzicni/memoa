//
//  CalendarView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

struct CalendarView: View {
    @Environment(DiaryStore.self) private var store
    @State private var selectedMonth = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Month Selector
                    HStack {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                        }
                        
                        Spacer()
                        
                        Text(selectedMonth.formatted(.dateTime.month(.wide).year()))
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding()
                    
                    // Calendar Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(daysInMonth, id: \.self) { date in
                            if let date = date {
                                DayCell(date: date, entries: entriesForDate(date))
                            } else {
                                Color.clear
                                    .frame(height: 60)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Calendar")
        }
    }
    
    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: selectedMonth)!
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        var dates: [Date?] = []
        
        // Add empty cells for days before the month starts
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        for _ in 1..<firstWeekday {
            dates.append(nil)
        }
        
        // Add all days in the month
        for day in 0..<days {
            if let date = calendar.date(byAdding: .day, value: day, to: interval.start) {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    private func entriesForDate(_ date: Date) -> [DiaryEntry] {
        let calendar = Calendar.current
        return store.entries.filter { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
    
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
}

struct DayCell: View {
    let date: Date
    let entries: [DiaryEntry]
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16))
                .foregroundStyle(Calendar.current.isDateInToday(date) ? .blue : .primary)
            
            if !entries.isEmpty {
                HStack(spacing: 2) {
                    ForEach(entries.prefix(3)) { entry in
                        Circle()
                            .fill(moodColor(entry.mood))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Calendar.current.isDateInToday(date) ? Color.blue.opacity(0.1) : Color.clear)
        )
    }
    
    private func moodColor(_ mood: DiaryEntry.Mood) -> Color {
        switch mood {
        case .happy, .excited: return .green
        case .calm, .neutral: return .blue
        case .sad, .anxious: return .orange
        }
    }
}

#Preview {
    CalendarView()
        .environment(DiaryStore())
}
